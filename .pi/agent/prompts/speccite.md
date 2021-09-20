---
description: Answer a question from the ArkTS spec only, with exact citations
argument-hint: "<question>"
---
Answer this question using **only** the specification files in the current spec tree (`*.rst`):

$@

Rules:
- Ignore implementation, tests, stdlib, compiler/runtime sources, and current behavior unless I explicitly ask for them.
- Base the answer only on spec text you can cite.
- If the spec is contradictory, incomplete, or underspecified, say so explicitly.
- Prefer the smallest set of relevant spec files instead of searching the whole repository.
- Quote exact wording when it is important to the conclusion.

Output format:
1. **Short answer**: Yes / No / Underspecified.
2. **Spec-only explanation**: concise reasoning based only on the cited spec text.
3. **Citations**: exact references in `file:line-line` form.
4. **Paste-ready citation block**: a short paragraph or bullet block I can reuse as-is.

If the question is ambiguous, ask **one** brief clarifying question before doing broader analysis.
