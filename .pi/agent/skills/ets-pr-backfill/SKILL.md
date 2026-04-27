---
name: ets-pr-backfill
description: Backfill plugins/ets/tests/ets-templates from a previously merged PR or commit range by extracting spec-based, meaningful, non-duplicated coverage from its tests and implementation changes, then mirror the finalized delta into plugins/ets/tests/ets-cts-7.0.
---

# ETS PR Backfill

Use this skill when a PR or commit range was merged without adding `ets-templates` coverage and you want to backfill compliance tests now.

Interpret `User:` as:

- a merge commit, or
- a revision range such as `A^..B`,
- optionally followed by a repository path if the source PR lived outside the current checkout.

## Core policy

Before doing anything else, read these references fully:

- `../shared/oracle.md`
- `../shared/dedup.md`
- `../shared/harvesting.md`
- `../shared/finding-schema.md`
- `references/pr-triage.md`
- `references/mapping-pr-tests-to-spec.md`

Key rule:

- PR tests are **candidate sources**, not truth.
- Do not blindly port a merged PR's tests into `ets-templates`.
- First map each candidate scenario back to a spec clause or a narrow derived invariant.
- Harvest only the cases that are spec-based, meaningful, and non-duplicated.

## Repository anchors

For the repository you will edit, use the maintained environment variables:

```bash
RUNTIME_REPO="${PI_RESOURCE_RUNTIME_REPO}"
SPEC_ROOT="${PI_LANG_SPEC}"
PI_SKILLS_ROOT="$HOME/.pi/agent/skills"
TEMPLATES_ROOT="$RUNTIME_REPO/plugins/ets/tests/ets-templates"
CTS_ROOT="$RUNTIME_REPO/plugins/ets/tests/ets-cts-7.0"
```

If the PR lived in a different checkout, use that checkout only as the source surface for diff/test inspection. Harvest into the current repository unless the user asks otherwise.

## Workflow

### 1. Triage the PR surface

Use the helper script on the source repository:

```bash
PI_SKILLS_ROOT="$HOME/.pi/agent/skills"
bash "$PI_SKILLS_ROOT/shared/scripts/pr_surface.sh" <rev-range-or-merge-commit> [repo-path]
```

From that output, identify:

- changed language tests,
- changed parser/checker/type-system files,
- changed spec-ish files,
- the core semantic scenario behind the PR.

### 2. Reduce the PR to semantic scenarios

Do not preserve incidental regression scaffolding if it is not needed for compliance coverage.

Extract scenarios such as:

- a rule that was previously unchecked,
- a nested context that behaves differently from an equivalent top-level form,
- a constraint/arity/visibility/reference rule triggered only through a specific construct.

### 3. Map scenarios to the spec

For each scenario:

- locate the spec clause under `$SPEC_ROOT`,
- write down the derived invariant in one sentence,
- decide whether the scenario is a real compliance case or just implementation-shaped regression scaffolding.

If you cannot map a scenario to the spec or a defensible invariant, do not harvest it into `ets-templates`.

### 4. Deduplicate against existing compliance coverage

Search existing `ets-templates` before adding anything. Do not limit yourself to the exact target directory.

Helpful command:

```bash
RUNTIME_REPO="${PI_RESOURCE_RUNTIME_REPO}"
PI_SKILLS_ROOT="$HOME/.pi/agent/skills"
python3 "$PI_SKILLS_ROOT/shared/scripts/find_related_tests.py" \
  --root "$RUNTIME_REPO/plugins/ets/tests/ets-templates" \
  --term "$TERM_1" \
  --term "$TERM_2"
```

### 5. Re-probe the minimal harvested forms

Do not assume the PR tests themselves are the best compliance shape. Reduce them to minimal meaningful cases and probe them if needed:

```bash
PI_SKILLS_ROOT="$HOME/.pi/agent/skills"
python3 "$PI_SKILLS_ROOT/shared/scripts/probe_cases.py" \
  --compiler /path/to/es2panda \
  --cases /tmp/backfill-cases.json
```

### 6. Harvest only the compliance delta, then mirror it

Add only tests that are:

1. spec-based,
2. meaningful,
3. unique.

Current implementation failure is not a reason to skip a valid compliance test.

First finalize the deduplicated delta in `ets-templates`. Then mirror the same finalized file set to matching paths under `ets-cts-7.0`.

## Expected output

When you finish, summarize:

1. the PR/range inspected,
2. the semantic scenarios extracted from it,
3. which scenarios were rejected as implementation-only or duplicate,
4. which files were added to `ets-templates`,
5. which files were mirrored to `ets-cts-7.0`,
6. any remaining ambiguities in spec mapping.
