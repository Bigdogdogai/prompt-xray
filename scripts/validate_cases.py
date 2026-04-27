#!/usr/bin/env python3
"""Validate Prompt X-Ray expected-behavior case files.

Pure stdlib port of scripts/validate_cases.rb. Runs on Python 3.8+.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CASE_DIR = ROOT / "tests/prompt-xray"
EXPECTED_NUMBERS = list(range(1, 21))
ALLOWED_MODES = {"Create", "Analyze", "Rewrite", "Test", "Compare", "Package", "None"}

SECTION_PATTERN_TEMPLATE = r"^## {heading}\n(.*?)(?=^## |\Z)"
INPUT_PROMPT_PATTERN = re.compile(
    r"^## Input Prompt\n\n(```text\n.*?\n```)\n\n## Expected Mode",
    re.DOTALL | re.MULTILINE,
)
MODE_SPLIT_PATTERN = re.compile(r"\s*/\s*|\s*,\s*|\s+or\s+")


def section(content: str, heading: str) -> str | None:
    pattern = re.compile(
        SECTION_PATTERN_TEMPLATE.format(heading=re.escape(heading)),
        re.DOTALL | re.MULTILINE,
    )
    match = pattern.search(content)
    return match.group(1).strip() if match else None


def input_prompt_section(content: str) -> str | None:
    match = INPUT_PROMPT_PATTERN.search(content)
    return match.group(1).strip() if match else None


def main() -> int:
    files = sorted(CASE_DIR.glob("*.md"))
    failures: list[str] = []
    numbers: list[int] = []

    for file in files:
        rel = file.relative_to(ROOT)
        content = file.read_text(encoding="utf-8")
        basename = file.name

        match = re.match(r"\A(\d{2})-", basename)
        number: int | None = int(match.group(1)) if match else None
        if number is not None:
            numbers.append(number)

        if number is None:
            failures.append(f"{rel}: filename must start with NN-")
            continue

        expected_title = f"# Case {number:02d}:"
        if not content.startswith(expected_title):
            failures.append(f"{rel}: title must start with {expected_title}")

        input_block = input_prompt_section(content)
        mode = section(content, "Expected Mode")
        findings = section(content, "Expected X-Ray Findings")
        repair = section(content, "Minimal Repair")

        if input_block is None:
            failures.append(f"{rel}: missing Input Prompt section")
        if mode is None:
            failures.append(f"{rel}: missing Expected Mode section")
        if findings is None:
            failures.append(f"{rel}: missing Expected X-Ray Findings section")
        if repair is None:
            failures.append(f"{rel}: missing Minimal Repair section")

        if input_block is not None and not re.match(
            r"\A```text\n.*\n```\Z", input_block, re.DOTALL
        ):
            failures.append(f"{rel}: Input Prompt must be a fenced text block")

        if mode is not None:
            modes = [m for m in MODE_SPLIT_PATTERN.split(mode) if m]
            unknown = [m for m in modes if m not in ALLOWED_MODES]
            if unknown:
                failures.append(
                    f"{rel}: unknown Expected Mode value(s): {', '.join(unknown)}"
                )

        if findings is not None:
            bullet_count = sum(1 for line in findings.splitlines() if line.startswith("- "))
            if bullet_count < 2:
                failures.append(
                    f"{rel}: Expected X-Ray Findings needs at least 2 bullet findings"
                )

        if repair is not None and len(repair) < 40:
            failures.append(f"{rel}: Minimal Repair is too short to be useful")

        if number in {16, 17, 18} and input_block is not None:
            body_match = re.match(r"\A```text\n(.*)\n```\Z", input_block, re.DOTALL)
            prompt_body = body_match.group(1) if body_match else ""
            prompt_lines = len(prompt_body.splitlines())
            if not (30 <= prompt_lines <= 80):
                failures.append(
                    f"{rel}: long-form case input must be 30-80 lines, got {prompt_lines}"
                )

    if sorted(numbers) != EXPECTED_NUMBERS:
        failures.append(
            f"case numbers must be consecutive {EXPECTED_NUMBERS[0]}-{EXPECTED_NUMBERS[-1]}; "
            f"got {sorted(n for n in numbers if n is not None)}"
        )

    if len(files) != len(EXPECTED_NUMBERS):
        failures.append(
            f"expected {len(EXPECTED_NUMBERS)} case files, got {len(files)}"
        )

    if not failures:
        print("PASS prompt-xray case structure")
        print(f"case_files={len(files)} long_form_cases=3 subtle_injection_cases=2")
        return 0

    for failure in failures:
        print(f"FAIL {failure}", file=sys.stderr)
    print(f"Case validation failed: {len(failures)} issue(s)", file=sys.stderr)
    return 1


if __name__ == "__main__":
    sys.exit(main())
