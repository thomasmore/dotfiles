---
name: ets-spec-gap-hunter
description: Find spec-based inconsistencies for an ETS language feature and harvest new, non-duplicated, meaningful tests into plugins/ets/tests/ets-templates, then mirror the finalized delta into plugins/ets/tests/ets-cts-7.0. Use when starting from a feature or language rule rather than a specific merged PR.
---

# ETS Spec Gap Hunter

Use this skill when the task is:

- investigate an ETS language feature,
- find implementation inconsistencies against the spec,
- and contribute the resulting compliance coverage to `plugins/ets/tests/ets-templates/`, then mirror the finalized delta to `plugins/ets/tests/ets-cts-7.0/`.

Interpret `User:` as the feature, rule, chapter, or semantic area to investigate.

## Core policy

Before doing anything else, read these references fully:

- `../shared/oracle.md`
- `../shared/dedup.md`
- `../shared/harvesting.md`
- `../shared/finding-schema.md`

The key rule is:

- `ets-templates` is a **spec compliance suite**.
- The **spec** is the oracle.
- Current implementation behavior is not the acceptance gate.
- A meaningful spec-based case may be harvested even if the current implementation rejects it, misdiagnoses it, accepts it incorrectly, crashes, asserts, or hangs.

## Repository anchors

Use the maintained environment variables:

```bash
RUNTIME_REPO="${PI_RESOURCE_RUNTIME_REPO}"
SPEC_ROOT="${PI_LANG_SPEC}"
PI_SKILLS_ROOT="$HOME/.pi/agent/skills"
TEMPLATES_ROOT="$RUNTIME_REPO/plugins/ets/tests/ets-templates"
CTS_ROOT="$RUNTIME_REPO/plugins/ets/tests/ets-cts-7.0"
```

If the task needs frontend implementation internals outside this repository, inspect the paired checkout the user points to and read its nearest `AGENTS.md` files before drawing conclusions.

## Workflow

### 1. Read local guidance and spec clauses

- Read the nearest `AGENTS.md` files for the current subtree and any paired frontend subtree you inspect.
- Read the relevant spec files under `$SPEC_ROOT` fully, not just grep snippets.
- Write down the exact clause(s) or the narrow invariant you derive from them.

### 2. Locate implementation surfaces

Look for the parser, binder, checker, type, and IR surfaces that implement the feature. Typical ETS frontend loci include areas such as:

- `parser/`
- `varbinder/`
- `checker/`
- `checker/types/ets/`
- `ir/ets/`

Do not stop at one file if the rule clearly crosses parser/binder/checker boundaries.

### 3. Inventory existing coverage before proposing new tests

Do not inspect only the immediate target directory. Search:

- the target feature directory,
- sibling directories in the same chapter,
- nearby owning directories for generics or type-system interactions.

Helpful command:

```bash
RUNTIME_REPO="${PI_RESOURCE_RUNTIME_REPO}"
PI_SKILLS_ROOT="$HOME/.pi/agent/skills"
python3 "$PI_SKILLS_ROOT/shared/scripts/find_related_tests.py" \
  --root "$RUNTIME_REPO/plugins/ets/tests/ets-templates" \
  --term "$FEATURE_TERM_1" \
  --term "$FEATURE_TERM_2"
```

Choose terms from feature names, expected diagnostics, nearby file names, and invariant wording.

### 4. Build a boundary/context matrix

For the feature, enumerate small meaningful axes such as:

- direct form vs aliased form,
- top-level vs nested context,
- class vs interface vs primitive constraint,
- exact vs missing vs extra type arguments,
- direct self-reference vs tuple/union/function/generic-argument wrapping.

Vary one semantic axis at a time.

### 5. Probe the implementation with minimal cases

Use the helper script when batch probing is useful:

```bash
PI_SKILLS_ROOT="$HOME/.pi/agent/skills"
cat > /tmp/ets-gap-cases.json <<'JSON'
{
  "cases": [
    {
      "name": "case_name",
      "code": "type A<T> = T\nlet x: A<int> = 1\n"
    }
  ]
}
JSON
python3 "$PI_SKILLS_ROOT/shared/scripts/probe_cases.py" \
  --compiler /path/to/es2panda \
  --cases /tmp/ets-gap-cases.json
```

Interpret outcomes using the schema from `../shared/finding-schema.md`.

### 6. Decide harvest eligibility

Harvest a finding into `ets-templates` only when it is:

1. spec-based,
2. meaningful,
3. unique after semantic dedup.

Do **not** reject a candidate just because the current implementation fails it.

### 7. Write the test in local chapter style, then mirror it

Before editing:

- inspect nearby `.ets` / `.params.yaml` patterns,
- choose a spec-oriented name,
- keep the case minimal,
- preserve the local metadata and header style.

First update `ets-templates`. After the template-side delta is finalized and deduplicated, mirror the same file set to matching paths under `ets-cts-7.0`.

## Expected output

When you finish, summarize:

1. spec clauses / invariants used,
2. implementation loci inspected,
3. duplicates or near-duplicates you skipped,
4. files added to `ets-templates`,
5. files mirrored to `ets-cts-7.0`,
6. findings that remain ambiguous.
