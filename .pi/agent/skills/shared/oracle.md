# Oracle for `ets-templates`

`plugins/ets/tests/ets-templates/` is a **language compliance suite**. Treat the **specification** as the only oracle for whether a candidate belongs in this suite.

## Inclusion rule

A candidate belongs in `ets-templates` when all of the following are true:

1. **Spec-based**
   - The case is justified by an explicit spec clause, or
   - by a narrow semantic invariant derived from the spec.
2. **Meaningful**
   - The case exercises a real language rule or boundary.
   - It is not just malformed garbage or foreign-language syntax with no spec basis.
3. **Non-duplicated**
   - Existing `ets-templates` coverage does not already exercise the same rule with the same effective semantic axis.

## What current implementation behavior means

Current implementation behavior is **evidence**, not the oracle.

Use current behavior only to classify the finding:

- compiles and behaves as expected
- rejects with expected diagnostic
- rejects with wrong diagnostic
- wrongly accepts invalid code
- wrongly rejects valid code
- crashes / asserts / hangs

A candidate is **not excluded** from `ets-templates` merely because the current implementation:

- fails it,
- emits the wrong diagnostic,
- accepts code that should be rejected,
- rejects code that should be accepted,
- crashes, asserts, or hangs.

If the case is spec-based, meaningful, and unique, it is still a valid compliance-suite candidate.

## Crashes

A crash/assert/hang on a meaningful spec-grounded candidate is an **implementation inconsistency**.

- If the spec implies acceptance, classify it as a failure on a valid case.
- If the spec implies ordinary rejection, classify it as a failure to report the expected error normally.

Either way, the crash is a compliance failure, not a reason to discard the candidate.

## What to reject

Reject a harvest candidate only when at least one of these is true:

- no solid spec basis,
- semantically duplicate or near-duplicate coverage already exists,
- the case is too malformed or implementation-shaped for a compliance suite,
- the spec is genuinely ambiguous and you cannot justify a stable expectation.

## PR backfill rule

When backfilling from a merged PR, treat PR tests as **candidate sources**, not truth.

Do not port a PR test into `ets-templates` until you can explain it in spec terms and confirm it is meaningful and non-duplicated.
