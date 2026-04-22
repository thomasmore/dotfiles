import * as os from "node:os";
import * as path from "node:path";
import type { ExtensionAPI, ExtensionContext } from "@mariozechner/pi-coding-agent";

const EXTENSION_TYPE = "paths-from-env";
// const WORKSPACE_ROOT = path.join(os.homedir(), "workspace");
const WORKSPACE_ROOT = os.homedir();

const KNOWN_PATH_VARS: ReadonlyArray<readonly [string, string]> = [
	["Runtime repo", "PI_RESOURCE_RUNTIME_REPO"],
	["Frontend repo", "PI_RESOURCE_FRONTEND_REPO"],
	["Build directory", "PI_BUILD_DIR"],
	["Generated tests directory", "PI_TEST_DIR"],
	["Language specification directory", "PI_LANG_SPEC"],
];

type PathHint = {
	label: string;
	envName: string;
	value: string;
};

function isWorkspaceProject(cwd: string): boolean {
	return cwd === WORKSPACE_ROOT || cwd.startsWith(`${WORKSPACE_ROOT}${path.sep}`);
}

function humanizeEnvName(envName: string): string {
	return envName
		.replace(/^PI_(PATH|RESOURCE)_/, "")
		.toLowerCase()
		.split("_")
		.filter(Boolean)
		.map((word) => word[0].toUpperCase() + word.slice(1))
		.join(" ");
}

function collectPathHints(): PathHint[] {
	const hints: PathHint[] = [];
	const seen = new Set<string>();

	for (const [label, envName] of KNOWN_PATH_VARS) {
		const value = process.env[envName]?.trim();
		if (!value) {
			continue;
		}

		hints.push({ label, envName, value });
		seen.add(envName);
	}

	for (const [envName, rawValue] of Object.entries(process.env).sort(([a], [b]) => a.localeCompare(b))) {
		const value = rawValue?.trim();
		if (!value || seen.has(envName)) {
			continue;
		}

		if (!envName.startsWith("PI_PATH_") && !envName.startsWith("PI_RESOURCE_")) {
			continue;
		}

		hints.push({
			label: humanizeEnvName(envName),
			envName,
			value,
		});
	}

	return hints;
}

function hasInjectedMessage(ctx: ExtensionContext): boolean {
	return ctx.sessionManager
		.getBranch()
		.some((entry) => entry.type === "custom_message" && entry.customType === EXTENSION_TYPE);
}

function buildMessage(hints: PathHint[]): string {
	const lines = hints.map(({ label, envName, value }) => `- ${label} (\`${envName}\`): \`${value}\``).join("\n");

	return `Canonical path hints loaded from environment for this session:

${lines}

Treat these as the preferred resource paths when relevant.`;
}

function getLatestInjectedEntry(ctx: ExtensionContext) {
	const entries = ctx.sessionManager.getEntries();
	for (let index = entries.length - 1; index >= 0; index--) {
		const entry = entries[index];
		if (entry.type === "custom_message" && entry.customType === EXTENSION_TYPE) {
			return entry;
		}
	}

	return null;
}

function getLoadedPathHints(ctx: ExtensionContext): { source?: string; hints: PathHint[] } | null {
	const entry = getLatestInjectedEntry(ctx);
	if (entry === null) {
		return null;
	}

	const source = typeof entry.details?.source === "string" ? entry.details.source : undefined;
	const rawHints = Array.isArray(entry.details?.hints) ? entry.details.hints : [];
	const hints = rawHints
		.filter(
			(hint): hint is { label: string; envName: string; value: string } =>
				typeof hint?.label === "string" && typeof hint?.envName === "string" && typeof hint?.value === "string",
		)
		.map(({ label, envName, value }) => ({ label, envName, value }));

	return hints.length === 0 ? null : { source, hints };
}

function injectPathHints(pi: ExtensionAPI, source: "session_start"): number {
	const hints = collectPathHints();
	if (hints.length === 0) {
		return 0;
	}

	pi.sendMessage({
		customType: EXTENSION_TYPE,
		content: buildMessage(hints),
		display: true,
		details: {
			workspaceRoot: WORKSPACE_ROOT,
			source,
			hints: hints.map(({ label, envName, value }) => ({ label, envName, value })),
		},
	});

	return hints.length;
}

export default function pathsFromEnv(pi: ExtensionAPI) {
	pi.on("session_start", async (_event, ctx) => {
		if (!isWorkspaceProject(ctx.cwd) || hasInjectedMessage(ctx)) {
			return;
		}

		const hintCount = injectPathHints(pi, "session_start");
		if (hintCount === 0) {
			return;
		}

		if (ctx.hasUI) {
			ctx.ui.notify(`Loaded ${hintCount} path hint(s) from environment`, "info");
		}
	});

	pi.registerCommand("paths-show", {
		description: "Show the currently loaded canonical path hints",
		handler: async (_args, ctx) => {
			const loaded = getLoadedPathHints(ctx);
			if (loaded === null) {
				ctx.ui.notify(
					isWorkspaceProject(ctx.cwd)
						? "No path hints are loaded for this session yet. Restart pi after updating environment variables if needed."
						: `paths-from-env is only active under ${WORKSPACE_ROOT}`,
					"info",
				);
				return;
			}

			const items = [
				...(loaded.source ? [`Source: ${loaded.source}`] : []),
				...loaded.hints.map(({ label, envName, value }) => `${label}: ${value} (${envName})`),
			];

			if (!ctx.hasUI) {
				ctx.ui.notify(items.join(" | "), "info");
				return;
			}

			const selected = await ctx.ui.select("Loaded Path Hints", items);
			if (selected !== undefined) {
				ctx.ui.notify(selected, "info");
			}
		},
	});
}
