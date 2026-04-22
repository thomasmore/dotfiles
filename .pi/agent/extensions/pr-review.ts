import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

const REMOTE_NAME = "alt";
const SPEC_DIR = process.env.PI_LANG_SPEC;

function formatExecError(command: string, args: string[], stdout: string, stderr: string): string {
	return [`$ ${command} ${args.join(" ")}`, stdout.trim(), stderr.trim()].filter(Boolean).join("\n");
}

async function execChecked(pi: ExtensionAPI, command: string, args: string[]): Promise<string> {
	const result = await pi.exec(command, args);
	if (result.code !== 0) {
		throw new Error(formatExecError(command, args, result.stdout, result.stderr));
	}
	return result.stdout.trim();
}

function buildReviewPrompt(params: {
	prNumber: number;
	remoteUrl: string;
	localRef: string;
	checkedOutBranch: string;
	lastSha: string;
	lastSubject: string;
	focus: string;
	mode?: "review" | "rereview";
	rereviewNotes?: string;
}): string {
	const { prNumber, remoteUrl, localRef, checkedOutBranch, lastSha, lastSubject, focus, mode, rereviewNotes } = params;

	const focusBlock = focus.trim()
		? `Pay extra attention to these pain-points:\n- ${focus.trim()}`
		: "No extra pain-points were specified.";
	const rereviewBlock = rereviewNotes?.trim()
		? [
			"Rereview context:",
			"- The author says previous review comments were addressed.",
			"- First verify whether the issues described below are actually fixed.",
			"- Then check whether the fix introduced any regressions or missed edge cases.",
			`- Previously reported issues / comments: ${rereviewNotes.trim()}`,
		].join("\n")
		: "";

	return [
		`${mode === "rereview" ? "Rereview" : "Review"} GitCode merge request #${prNumber}, but review ONLY the last commit.`,
		"",
		`Language specification:`,
		`- Spec root directory: ${SPEC_DIR}`,
		`- Read the relevant spec files before judging behavior.`,
		`- Use the spec as the source of truth for language behavior.`,
		`- If implementation or tests differ from the spec, call that out explicitly.`,
		`- If behavior is not clearly covered by the spec, say that instead of guessing.`,
		"",
		`Fetch details:`,
		`- remote name: ${REMOTE_NAME}`,
		`- remote URL: ${remoteUrl}`,
		`- local ref: ${localRef}`,
		`- checked out local branch: ${checkedOutBranch}`,
		`- last commit SHA: ${lastSha}`,
		`- last commit subject: ${lastSubject || "(unknown)"}`,
		"",
		focusBlock,
		rereviewBlock,
		"",
		`Rules:`,
		`1. Review only the last commit, not the full MR history.`,
		`2. Inspect only files touched by the last commit.`,
		`3. The PR branch is already checked out locally. You may inspect, build, run tests, and make temporary local modifications if that helps validate behavior, but do not create commits or switch away from the checked out PR branch.`,
		`4. Check correctness against the language specification first, then look for regressions, edge cases, missing tests, and the requested pain-points.`,
		`5. Use concrete file and symbol references whenever possible.`,
		`6. If you make local modifications to validate a hypothesis, mention that briefly in the review output.`,
		`7. If no issues are found, say "No issues found" and summarize what you checked.`,
		"",
		`Suggested commands:`,
		`- git show --stat --summary ${lastSha}`,
		`- git diff-tree --no-commit-id --name-only -r ${lastSha}`,
		`- git diff ${lastSha}^ ${lastSha}`,
		`- git show ${lastSha} --`,
		`- find relevant .rst files under ${SPEC_DIR}`,
		`- read the relevant spec sections from ${SPEC_DIR}`,
		`- inspect changed files with read, grep, find, ls, bash, edit, and write as needed`,
		`- if ${lastSha} has no parent, use git show ${lastSha} instead of git diff ${lastSha}^ ${lastSha}`,
		"",
		`Output format:`,
		`- Findings ordered by severity`,
		`- For each finding: severity, location, spec basis (if applicable), explanation, suggested fix`,
		`- If nothing is wrong: "No issues found"`,
	].join("\n");
}

export default function prReviewExtension(pi: ExtensionAPI) {
	let previousTools: string[] | undefined;
	let reviewInProgress = false;
	let lastReviewedPrNumber: number | undefined;

	function getRememberedPrNumber(): number | undefined {
		if (lastReviewedPrNumber !== undefined) {
			return lastReviewedPrNumber;
		}

		const sessionName = pi.getSessionName()?.trim();
		if (!sessionName) {
			return undefined;
		}

		const match = sessionName.match(/(?:^|\b)(?:MR|PR)\s+(\d+)\b/i);
		if (!match) {
			return undefined;
		}

		const prNumber = Number(match[1]);
		return Number.isFinite(prNumber) ? prNumber : undefined;
	}

	function restoreTools(): void {
		if (previousTools) {
			pi.setActiveTools(previousTools);
			previousTools = undefined;
		}
	}

	pi.on("agent_end", async () => {
		if (!reviewInProgress) {
			return;
		}

		reviewInProgress = false;
		restoreTools();
	});

	async function startReview(
		args: string,
		ctx: any,
		options?: {
			mode?: "review" | "rereview";
			defaultNotes?: string;
		},
	): Promise<void> {
		const mode = options?.mode ?? "review";
		const commandName = mode === "rereview" ? "/pr-rereview" : "/pr-review";

		if (!ctx.isIdle()) {
			ctx.ui.notify(`Wait for the current task to finish, then run ${commandName} again.`, "warning");
			return;
		}

		const trimmedArgs = args.trim();
		const match = trimmedArgs.match(/^(\d+)(?:\s+(.*))?$/s);
		let prNumberText = match?.[1] ?? "";
		let focus = match ? match[2]?.trim() ?? "" : trimmedArgs;
		const rememberedPrNumber = getRememberedPrNumber();

		if (!prNumberText && rememberedPrNumber !== undefined) {
			prNumberText = String(rememberedPrNumber);
		}

		if (!prNumberText) {
			prNumberText =
				(await ctx.ui.input(
					"Merge request number",
					rememberedPrNumber !== undefined ? String(rememberedPrNumber) : "10439",
				))?.trim() ?? "";
		}
		if (!prNumberText) {
			return;
		}

		if (!focus) {
			focus =
				(await ctx.ui.input(
					"Pain-points to check (optional)",
					"e.g. nullability, error handling, missing tests",
				))?.trim() ?? "";
		}

		let rereviewNotes = options?.defaultNotes ?? "";
		if (mode === "rereview") {
			rereviewNotes =
				(await ctx.ui.input(
					"Previously reported issues/comments to verify",
					"e.g. null-check is missing in foo(), test coverage for empty input is missing",
				))?.trim() ?? "";
		}

		try {
			await execChecked(pi, "git", ["rev-parse", "--is-inside-work-tree"]);

			const remoteUrl = await execChecked(pi, "git", ["remote", "get-url", REMOTE_NAME]);
			const prNumber = Number(prNumberText);
			const localRef = `pr_${prNumber}`;
			const checkedOutBranch = localRef;

			await execChecked(pi, "git", [
				"fetch",
				remoteUrl,
				`+refs/merge-requests/${prNumber}/head:${localRef}`,
			]);
			await execChecked(pi, "git", ["checkout", checkedOutBranch]);
			await execChecked(pi, "git", ["reset", "--hard", localRef]);

			lastReviewedPrNumber = prNumber;
			const lastSha = await execChecked(pi, "git", ["rev-parse", checkedOutBranch]);
			const lastSubject = await execChecked(pi, "git", ["show", "-s", "--format=%s", lastSha]);

			const availableTools = new Set(pi.getAllTools().map((tool) => tool.name));
			const reviewTools = ["read", "bash", "edit", "write", "grep", "find", "ls"].filter((name) => availableTools.has(name));

			previousTools = pi.getActiveTools();
			if (reviewTools.length > 0) {
				pi.setActiveTools(reviewTools);
			}

			reviewInProgress = true;
			pi.setSessionName(`MR ${prNumber} last-commit ${mode}`);
			pi.sendUserMessage(
				buildReviewPrompt({
					prNumber,
					remoteUrl,
					localRef,
					checkedOutBranch,
					lastSha,
					lastSubject,
					focus,
					mode,
					rereviewNotes,
				}),
			);

			ctx.ui.notify(`Started last-commit ${mode} for MR #${prNumber} on local branch ${checkedOutBranch}`, "info");
		} catch (error) {
			reviewInProgress = false;
			restoreTools();
			ctx.ui.notify(error instanceof Error ? error.message : String(error), "error");
		}
	}

	pi.registerCommand("pr-review", {
		description: "Fetch a GitCode MR from remote 'alt' and review only its last commit",
		handler: async (args, ctx) => {
			await startReview(args, ctx, { mode: "review" });
		},
	});

	pi.registerCommand("pr-rereview", {
		description: "Fetch a GitCode MR from remote 'alt' and rereview only its last commit after comments were addressed",
		handler: async (args, ctx) => {
			await startReview(args, ctx, { mode: "rereview" });
		},
	});
}
