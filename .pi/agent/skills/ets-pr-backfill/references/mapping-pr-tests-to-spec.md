# Mapping PR tests to the spec

A merged PR test is not automatically a compliance test.

Use this reduction process.

## Step 1: Identify the semantic core

Strip away:

- incidental declarations,
- unrelated helper types,
- regression comments,
- issue-specific naming,
- extra assertions not needed for the language rule.

Keep only the smallest form that still exercises the same rule.

## Step 2: Write the rule in spec language

State the scenario as one sentence using spec terminology, for example:

- generic constraints are enforced through alias instantiation,
- circular alias references are rejected even when nested in tuple elements,
- type argument arity is preserved through alias use.

If you cannot state the rule in spec language, the test probably is not ready for `ets-templates`.

## Step 3: Find the owning clause

Locate the clause in `plugins/ets/doc/spec/` that directly states the rule or clearly supports the invariant.

Prefer:

- exact rule statements,
- grammar + semantics combination,
- nearby definitions that make the intended behavior explicit.

## Step 4: Generalize from regression shape to compliance shape

Turn implementation- or bug-shaped tests into feature-shaped compliance tests.

Examples:

- `issue_32651.ets` becomes a generic constraint test named by the language feature,
- `alias_crash_regression_n.ets` becomes a recursive-alias or arity/constraint/context test if the spec supports it,
- a parser regression with several unrelated constructs becomes one or more minimal focused cases.

## Step 5: Run the dedup check

Before harvesting, compare the generalized test against existing `ets-templates` coverage. If it only restates an existing rule with no new semantic axis, skip it.
