# Semantic dedup for `ets-templates`

Deduplication for compliance tests must be **semantic**, not purely textual.

## Compare candidates by coverage key

For each candidate, write down this coverage key before deciding to add it:

1. **Spec clause / invariant**
   - Which rule is being exercised?
2. **Intent**
   - positive (accept) or negative (reject)
3. **Primary semantic axis**
   - What changed relative to the closest known case?
   - Examples: direct vs aliased form, exact vs extra type arguments, class vs interface constraint.
4. **Context / nesting position**
   - top level, tuple element, union member, function parameter, generic argument, array element, etc.
5. **Expected outcome family**
   - accept, reject, wrong diagnostic, crash on meaningful case, etc.

Two tests are near-duplicates when these fields line up closely enough that they exercise the same rule with no materially new semantic axis.

## Search roots

Do not deduplicate only against the immediate directory.

Always search:

1. the target feature directory,
2. sibling directories in the same spec chapter,
3. nearby directories that own the same semantic area,
4. cross-cutting generic/type-system directories when the feature overlaps with them.

For ETS in this repository, this often includes both:

- the local feature chapter under `plugins/ets/tests/ets-templates/`, and
- neighboring generic/type-alias/type-parameter coverage under `05.generics/` or other owning chapters.

## Duplicate decisions

Use these buckets:

- **exact duplicate**: same rule, same axis, same effective coverage
- **near duplicate**: slightly different syntax, but no meaningful new semantic coverage
- **unique**: adds a clearly new semantic axis or context
- **ambiguous**: might be unique, but you need more spec or inventory work before deciding

## Preference rule

If two candidates cover the same rule, keep the one that is:

1. smaller,
2. clearer,
3. more directly tied to the spec wording,
4. less implementation-shaped.

## Suggested helper script

From the repository root:

```bash
RUNTIME_REPO="${PI_RESOURCE_RUNTIME_REPO}"
PI_SKILLS_ROOT="$HOME/.pi/agent/skills"
python3 "$PI_SKILLS_ROOT/shared/scripts/find_related_tests.py" \
  --root "$RUNTIME_REPO/plugins/ets/tests/ets-templates" \
  --term "type alias" \
  --term "generic_type_alias" \
  --term "constraint" \
  --term "ESE0228"
```

Use terms taken from:

- feature names,
- expected diagnostics,
- nearby file names,
- important type names or constructs,
- invariant wording.

Then inspect the strongest matches manually before deciding to add a new case.
