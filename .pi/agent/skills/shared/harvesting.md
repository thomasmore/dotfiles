# Harvesting findings into `ets-templates` and `ets-cts-7.0`

Once a finding is shown to be spec-based, meaningful, and unique, convert it into `plugins/ets/tests/ets-templates/` coverage and then mirror the finalized delta into `plugins/ets/tests/ets-cts-7.0/`.

## General rules

1. **Match local chapter style**
   - Inspect nearby `.ets` and `.params.yaml` files first.
   - Follow the dominant template style in the target directory.
2. **Use spec-oriented names**
   - Name files by feature and sub-feature.
   - Avoid names based on implementation, bug history, crash, regression, or differences.
3. **Minimize the test**
   - Keep only the declarations and uses needed to exercise the rule.
4. **Do not gate on current implementation success**
   - `ets-templates` is a compliance suite.
   - Current failure, wrong diagnostic, or crash is not a reason to skip a valid candidate.
5. **Mirror only after finalizing the `ets-templates` delta**
   - First finish deduplication and minimization in `ets-templates`.
   - Then port the same finalized file set into `ets-cts-7.0`.
   - Do not mirror early and then keep pruning two trees in parallel.

## Positive vs negative shape

Use the local directory conventions.

Common patterns in `ets-templates` include:

- `feature.ets` for positive coverage
- `feature_n.ets` for negative coverage
- paired `.params.yaml` files when the chapter uses parameterized templates

Do not invent a new harness style if the local chapter already has one.

## Parameterization rule

Parameterize only when the grouped cases truly share:

- one spec rule or one narrow invariant,
- one expected outcome family,
- one natural template shape.

Split into separate files when cases differ materially in rule, context, or expectation.

## Expected diagnostics

When the local chapter already checks exact or near-exact diagnostics, reuse that style.

Prefer the narrowest stable expectation that the surrounding suite already uses, for example:

- explicit diagnostic code and message when that chapter already relies on them,
- otherwise the local negative-test pattern used by neighboring files.

If the spec basis is solid but exact wording is unstable, keep the case but align its expectation style with nearby tests rather than inventing a new convention.

## Headers and metadata

Preserve the standard license header and the local metadata/comment style already used in the target directory.

## Final checklist

Before writing files, verify:

- spec clause or invariant is written down,
- nearest existing tests were checked,
- the case is minimal,
- the file name is spec-oriented,
- the chosen template shape matches the local directory,
- the addition does not merely duplicate existing coverage,
- the finalized `ets-templates` files are mirrored to matching `ets-cts-7.0` paths only after the template-side set is stable.
