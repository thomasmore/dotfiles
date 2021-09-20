#!/usr/bin/env python3
"""Batch-compile small ETS snippets and classify the observed outcome."""

from __future__ import annotations

import argparse
import json
import os
import shutil
import signal
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Any


DEFAULT_SUFFIX = ".ets"
MAX_CAPTURE = 12000


def load_cases(path: Path) -> list[dict[str, Any]]:
    data = json.loads(path.read_text(encoding="utf-8"))
    if isinstance(data, list):
        return data
    if isinstance(data, dict) and isinstance(data.get("cases"), list):
        return data["cases"]
    raise SystemExit("cases file must contain either a list or an object with a 'cases' list")


def truncate(text: str) -> str:
    return text if len(text) <= MAX_CAPTURE else text[:MAX_CAPTURE] + "\n...[truncated]"


def first_interesting_line(*streams: str) -> str:
    for stream in streams:
        for line in stream.splitlines():
            stripped = line.strip()
            if not stripped:
                continue
            lowered = stripped.lower()
            if any(token in lowered for token in ("error", "exception", "assert", "segmentation fault", "abort")):
                return stripped
    for stream in streams:
        for line in stream.splitlines():
            stripped = line.strip()
            if stripped:
                return stripped
    return ""


def classify(returncode: int, timed_out: bool) -> tuple[str, str | None]:
    if timed_out:
        return "timeout", None
    if returncode == 0:
        return "accept", None
    if returncode < 0:
        sig = signal.Signals(-returncode).name
        return "crash", sig
    return "reject", None


def build_command(compiler: str, compiler_args: list[str], source_path: Path, extra_args: list[str]) -> list[str]:
    return [compiler, *compiler_args, *extra_args, str(source_path)]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler", required=True, help="Path to es2panda or another frontend/compiler binary")
    parser.add_argument("--cases", required=True, help="JSON file containing cases")
    parser.add_argument("--cwd", default=None, help="Working directory for compiler execution")
    parser.add_argument("--timeout", type=float, default=20.0, help="Per-case timeout in seconds")
    parser.add_argument("--suffix", default=DEFAULT_SUFFIX, help="Source file suffix to use for temporary files")
    parser.add_argument("--keep-temp", action="store_true", help="Keep generated files and temp directory")
    parser.add_argument(
        "--compiler-arg",
        action="append",
        default=[],
        help="Extra argument passed to the compiler for every case; repeat as needed",
    )
    args = parser.parse_args()

    compiler = os.path.expanduser(args.compiler)
    compiler_args = list(args.compiler_arg)
    cases = load_cases(Path(args.cases))
    exec_cwd = args.cwd or os.getcwd()

    results: list[dict[str, Any]] = []

    temp_dir = Path(tempfile.mkdtemp(prefix="ets-gap-"))
    try:
        for index, case in enumerate(cases):
            name = case.get("name") or f"case_{index}"
            suffix = case.get("suffix", args.suffix)
            filename = case.get("filename") or f"{name}{suffix}"
            code = case.get("code")
            if not isinstance(code, str):
                raise SystemExit(f"case {name!r} is missing string field 'code'")

            source_path = temp_dir / filename
            source_path.parent.mkdir(parents=True, exist_ok=True)
            source_path.write_text(code, encoding="utf-8")

            extra_args = case.get("extra_args") or []
            if not isinstance(extra_args, list) or not all(isinstance(item, str) for item in extra_args):
                raise SystemExit(f"case {name!r} has invalid 'extra_args' field")

            case_cwd = case.get("cwd") or exec_cwd
            command = build_command(compiler, compiler_args, source_path, extra_args)
            timed_out = False
            try:
                completed = subprocess.run(
                    command,
                    cwd=case_cwd,
                    capture_output=True,
                    text=True,
                    timeout=args.timeout,
                    check=False,
                )
                stdout = completed.stdout
                stderr = completed.stderr
                returncode = completed.returncode
            except subprocess.TimeoutExpired as exc:
                timed_out = True
                stdout = exc.stdout or ""
                stderr = exc.stderr or ""
                returncode = 124

            status, signal_name = classify(returncode, timed_out)
            results.append(
                {
                    "name": name,
                    "filename": str(source_path),
                    "cwd": case_cwd,
                    "command": command,
                    "status": status,
                    "returncode": returncode,
                    "signal": signal_name,
                    "summary": first_interesting_line(stderr, stdout),
                    "stdout": truncate(stdout),
                    "stderr": truncate(stderr),
                }
            )

        payload = {
            "compiler": compiler,
            "cwd": exec_cwd,
            "caseCount": len(cases),
            "results": results,
        }
        json.dump(payload, sys.stdout, indent=2)
        sys.stdout.write("\n")
        return 0
    finally:
        if args.keep_temp:
            print(f"[probe_cases.py] kept temporary files in {temp_dir}", file=sys.stderr)
        else:
            shutil.rmtree(temp_dir, ignore_errors=True)


if __name__ == "__main__":
    raise SystemExit(main())
