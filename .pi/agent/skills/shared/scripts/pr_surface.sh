#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 1 && ( "$1" == "-h" || "$1" == "--help" ) ]]; then
    echo "Usage: $0 <rev-range-or-merge-commit> [repo-path]"
    exit 0
fi

if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "Usage: $0 <rev-range-or-merge-commit> [repo-path]" >&2
    exit 1
fi

RANGE_INPUT="$1"
REPO_PATH="${2:-.}"

cd "$REPO_PATH"

git rev-parse --is-inside-work-tree >/dev/null

if [[ "$RANGE_INPUT" == *..* ]]; then
    RANGE="$RANGE_INPUT"
else
    RANGE="${RANGE_INPUT}^!"
fi

echo "== Repo =="
pwd

echo
echo "== Range =="
echo "$RANGE"

echo
echo "== Commits =="
git log --oneline "$RANGE"

echo
echo "== Changed files =="
git diff --name-status "$RANGE"

echo
echo "== Changed tests =="
git diff --name-only "$RANGE" | grep -E '(^|/)(test|tests|ets-templates|ets-cts|checked|compiler)/' || true

echo
echo "== Changed ETS/frontend files =="
git diff --name-only "$RANGE" | grep -E '(^|/)(parser|checker|varbinder|ir|compiler|plugins/ets|runtime)/' || true

echo
echo "== Added/removed spec-ish or template-ish files =="
git diff --name-status "$RANGE" | grep -E '(doc/spec|ets-templates|ets-cts|test/ast|test/parser|test/checker)' || true
