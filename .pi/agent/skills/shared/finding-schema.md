# Finding schema

Use the same compact schema for feature-driven gap hunting and PR backfill.

## Required fields

- `source_mode`
  - `feature-scan` or `pr-backfill`
- `subject`
  - feature name or PR/range identifier
- `spec_clause`
  - exact file/section reference when possible
- `invariant`
  - one-sentence semantic rule derived from the spec
- `candidate_summary`
  - one-line description of the probe or harvested case
- `expected_by_spec`
  - `accept`, `reject`, or `ambiguous`
- `observed_now`
  - `accept`, `reject`, `wrong-diagnostic`, `wrong-accept`, `wrong-reject`, `crash`, `assert`, or `hang`
- `duplicate_status`
  - `exact-duplicate`, `near-duplicate`, `unique`, or `ambiguous`
- `harvest_decision`
  - `add`, `skip-duplicate`, `hold-ambiguous`, `report-only`
- `notes`
  - shortest useful explanation

## Optional fields

- `implementation_locus`
- `closest_existing_tests`
- `expected_diagnostic`
- `current_diagnostic`
- `repro_command`
- `target_path`

## Minimal table form

| subject | spec_clause | invariant | expected_by_spec | observed_now | duplicate_status | harvest_decision | notes |
|---|---|---|---|---|---|---|---|

## Decision guidance

- `harvest_decision=add` only when the candidate is spec-based, meaningful, and unique.
- `report-only` is appropriate for implementation curiosities with weak or unclear spec grounding.
- A crash on a meaningful spec-based case may still be `add` if the case belongs in the compliance suite.
