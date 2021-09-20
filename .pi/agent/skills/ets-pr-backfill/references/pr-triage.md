# PR triage for backfilling `ets-templates`

The purpose of PR triage is to turn a merged change set into a short list of language scenarios worth evaluating for compliance coverage.

## What to extract from a PR

Look for these buckets:

1. **Changed tests**
   - frontend parser/checker tests
   - compiler tests
   - runtime tests
   - regression files
2. **Changed implementation files**
   - parser
   - binder
   - checker
   - type system
   - runtime entrypoints only if the feature is runtime-visible
3. **Changed documentation/spec notes**
   - explicit spec updates
   - comments or issue links explaining intent

## Questions to answer

For each changed test or code path, answer:

- What language rule is this really about?
- Is the test probing a spec rule or just a regression path?
- What is the smallest semantically meaningful form of the scenario?
- Does the PR expose a missing context variant that the compliance suite should own?

## Good PR signals for backfill

A PR is a strong backfill candidate when it:

- fixes a real language rule,
- adds a checker/parser/type-system test for a meaningful scenario,
- exposes different behavior across equivalent contexts,
- adds support for a previously missing spec feature,
- tightens diagnostics for a clearly specified error.

## Weak PR signals

A PR is a weak direct backfill source when it mostly contains:

- temporary regression scaffolding,
- unsupported foreign syntax with no ETS spec basis,
- crash-only stress inputs with little semantic meaning,
- oversized tests that combine several unrelated rules.

Weak signals can still inspire a compliance test, but only after reduction and spec mapping.
