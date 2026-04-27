#!/usr/bin/env python3
"""Search test roots for semantically related files using simple weighted terms."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any


TEXT_EXTENSIONS = {".ets", ".yaml", ".yml", ".md", ".txt", ".err"}


def scan_file(path: Path, terms: list[str], max_bytes: int) -> dict[str, Any] | None:
    lowered_path = str(path).lower()
    basename = path.name.lower()
    score = 0
    reasons: list[str] = []
    matches: list[dict[str, Any]] = []

    for term in terms:
        if term in basename:
            score += 5
            reasons.append(f"basename contains '{term}'")
        elif term in lowered_path:
            score += 3
            reasons.append(f"path contains '{term}'")

    text = ""
    if path.suffix.lower() in TEXT_EXTENSIONS:
        try:
            raw = path.read_text(encoding="utf-8", errors="ignore")
        except OSError:
            raw = ""
        text = raw[:max_bytes]
        lowered_text = text.lower()
        for term in terms:
            if term in lowered_text:
                count = lowered_text.count(term)
                score += min(4, count)
                reasons.append(f"content contains '{term}' x{count}")
                line_hits = []
                for line_no, line in enumerate(text.splitlines(), start=1):
                    if term in line.lower():
                        line_hits.append({"line": line_no, "text": line.strip()[:240]})
                    if len(line_hits) >= 3:
                        break
                matches.extend({"term": term, **hit} for hit in line_hits)

    if score == 0:
        return None

    return {
        "path": str(path),
        "score": score,
        "reasons": reasons,
        "matches": matches,
    }


def iter_files(root: Path) -> list[Path]:
    if root.is_file():
        return [root]
    return [path for path in root.rglob("*") if path.is_file()]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", action="append", required=True, help="Root directory or file to search; repeat as needed")
    parser.add_argument("--term", action="append", required=True, help="Lower-cased search term; repeat as needed")
    parser.add_argument("--limit", type=int, default=40, help="Maximum number of matches to print")
    parser.add_argument("--max-bytes", type=int, default=60000, help="Maximum bytes of file content to scan per file")
    args = parser.parse_args()

    terms = [term.lower() for term in args.term]
    seen: set[Path] = set()
    results: list[dict[str, Any]] = []

    for root_arg in args.root:
        root = Path(root_arg)
        for path in iter_files(root):
            if path in seen:
                continue
            seen.add(path)
            hit = scan_file(path, terms, args.max_bytes)
            if hit is not None:
                results.append(hit)

    results.sort(key=lambda item: (-item["score"], item["path"]))
    json.dump({"terms": terms, "results": results[: args.limit]}, fp=sys.stdout, indent=2)
    sys.stdout.write("\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
