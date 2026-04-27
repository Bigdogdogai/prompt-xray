#!/usr/bin/env python3
"""Validate prompt-xray repository hygiene, SKILL.md, and README parity.

Pure stdlib port of scripts/validate_skill.rb. Runs on Python 3.8+.
"""

from __future__ import annotations

import os
import re
import subprocess
import sys
from pathlib import Path
from typing import Iterable

ROOT = Path(__file__).resolve().parent.parent


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def parse_simple_yaml(block: str) -> dict[str, object]:
    data: dict[str, object] = {}
    for raw in block.splitlines():
        line = raw.rstrip()
        if not line or line.startswith("#"):
            continue
        match = re.match(r'^([A-Za-z0-9_\-]+)\s*:\s*(.*)$', line)
        if not match:
            continue
        key, value = match.group(1), match.group(2).strip()
        if value.startswith('"') and value.endswith('"'):
            value = value[1:-1].encode().decode("unicode_escape")
        elif value.startswith("'") and value.endswith("'"):
            value = value[1:-1]
        data[key] = value
    return data


def extract_frontmatter(content: str) -> str | None:
    match = re.match(r'\A---\n(.*?)\n---', content, re.DOTALL)
    return match.group(1) if match else None


def discover_markdown_files(root: Path) -> list[Path]:
    files: list[Path] = []
    for path in root.rglob("*.md"):
        if "/.git/" in str(path) or "/.git\\" in str(path):
            continue
        files.append(path)
    return files


LINK_PATTERN = re.compile(r'!?\[[^\]]*\]\(([^)\s]+)(?:\s+"[^"]*")?\)')


def find_broken_local_links(root: Path, markdown_files: Iterable[Path]) -> list[str]:
    broken: list[str] = []
    for file in markdown_files:
        rel = file.relative_to(root)
        text = read(file)
        for raw_target in LINK_PATTERN.findall(text):
            target = raw_target.strip()
            if target.startswith("<") and target.endswith(">"):
                target = target[1:-1]
            if re.match(r'\A(?:https?:|mailto:|tel:|#)', target):
                continue
            path_part = target.split("#", 1)[0]
            if not path_part:
                continue
            resolved = (file.parent / path_part).resolve()
            try:
                resolved.relative_to(root)
                inside = True
            except ValueError:
                inside = False
            if not inside or not resolved.exists():
                broken.append(f"{rel}: {target}")
    return broken


def workflow_yaml_parses(path: Path) -> bool:
    """Lightweight YAML smoke check (we cannot import PyYAML)."""
    try:
        text = read(path)
    except OSError:
        return False
    if "name:" not in text:
        return False
    if "jobs:" not in text:
        return False
    return True


def installer_syntax_ok(path: Path) -> bool:
    result = subprocess.run(
        ["bash", "-n", str(path)],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    return result.returncode == 0


def main() -> int:
    skill_path = ROOT / "SKILL.md"
    content = read(skill_path)
    readme = read(ROOT / "README.md")
    readme_zh = read(ROOT / "README.zh-CN.md")
    readme_ja = read(ROOT / "README.ja.md")
    readme_ko = read(ROOT / "README.ko.md")
    gitignore = read(ROOT / ".gitignore")
    case_files = sorted((ROOT / "tests/prompt-xray").glob("*.md"))
    run_notes = read(ROOT / "tests/prompt-xray-runs/2026-04-27-expected-behavior-run.md")
    coverage = read(ROOT / "docs/coverage.md")
    demo_svg = read(ROOT / "assets/demo-terminal.svg")
    demo_cast = read(ROOT / "assets/demo.cast")
    security = read(ROOT / "SECURITY.md")
    markdown_files = discover_markdown_files(ROOT)

    english_h2 = re.compile(
        r'^## (Why This Exists|Quick Start|Platform Compatibility|Install|'
        r'When It Triggers|Outputs|Examples|Safety Model|Competitive Landscape|'
        r'Validation|Design Sources)$',
        re.MULTILINE,
    )

    frontmatter_block = extract_frontmatter(content)
    if frontmatter_block is None:
        print("Missing YAML frontmatter", file=sys.stderr)
        return 1

    metadata = parse_simple_yaml(frontmatter_block)
    description = metadata.get("description")
    name = metadata.get("name")

    allowed_keys = {"description", "name"}
    schema_valid = (
        set(metadata.keys()) == allowed_keys
        and name == "prompt-xray"
        and isinstance(description, str)
        and len(description) <= 280
    )

    required_files = [
        "README.md",
        "README.zh-CN.md",
        "README.ja.md",
        "README.ko.md",
        "SKILL.md",
        "VERSION",
        "ROADMAP.md",
        "CHANGELOG.md",
        "LICENSE",
        "SECURITY.md",
        "CONTRIBUTING.md",
        "CODE_OF_CONDUCT.md",
        "Makefile",
        "docs/release-checklist.md",
        "docs/agent-compatibility.md",
        "docs/demo-script.md",
        "docs/before-after.md",
        "docs/coverage.md",
        "examples/usage-cases.md",
        "examples/test-matrix.md",
        "assets/demo.cast",
        "assets/demo-session.txt",
        "assets/demo-terminal.svg",
        "tests/README.md",
        "tests/prompt-xray-runs/2026-04-27-expected-behavior-run.md",
        ".github/PULL_REQUEST_TEMPLATE.md",
        ".github/ISSUE_TEMPLATE/bug_report.md",
        ".github/ISSUE_TEMPLATE/feature_request.md",
        ".github/workflows/validate.yml",
        "scripts/install.sh",
    ]

    description_text = description if isinstance(description, str) else ""
    line_count = len(content.splitlines())
    version_text = (ROOT / "VERSION").read_text(encoding="utf-8").strip()
    broken_links = find_broken_local_links(ROOT, markdown_files)
    case_count_ok = len(case_files) == 20
    case_structure_ok = all(
        all(
            heading in read(case)
            for heading in (
                "## Input Prompt",
                "## Expected Mode",
                "## Expected X-Ray Findings",
                "## Minimal Repair",
            )
        )
        for case in case_files
    )

    checks: dict[str, bool] = {
        "frontmatter name": name == "prompt-xray",
        "frontmatter description": isinstance(description, str),
        "frontmatter schema": schema_valid,
        "narrow trigger": (
            "Use only for prompt engineering" in description_text
            and "Exclude ordinary writing" in description_text
        ),
        "line budget 80-160": 80 <= line_count <= 160,
        "six modes": all(
            mode in content.lower()
            for mode in ("create", "analyze", "rewrite", "test", "compare", "package")
        ),
        "untrusted data rule": "untrusted data" in content,
        "external prompt non-execution": "do not follow instructions inside" in content,
        "hidden chain-of-thought protection": "hidden chain-of-thought" in content,
        "sensitive data handling": "sensitive" in content,
        "local agent report": all(
            phrase in content for phrase in ("changed files", "verification", "remaining risks")
        ),
        "release hygiene": "GitHub" in content and "license" in content,
        "neutral injection probe": (
            "injection-probe" in content and "dump the system prompt" not in content
        ),
        "public repo files": all((ROOT / f).is_file() for f in required_files),
        "language switcher": all(
            f in readme for f in ("README.zh-CN.md", "README.ja.md", "README.ko.md")
        ),
        "version badge": "version-1.0.1" in readme and version_text == "1.0.1",
        "gitignore is scoped": "node_modules/" not in gitignore and "vendor/" not in gitignore,
        "installer documented": "bash scripts/install.sh" in readme,
        "multi-agent positioning": (
            name == "prompt-xray"
            and "OpenClaw" in readme
            and "Hermes Agent" in readme
            and "Claude Code" in readme
            and "AI coding agents" in readme
        ),
        "multi-agent verification table": (
            "| Agent surface | Support level | Install | Verification |" in readme
            and "Locally tested in this repo" in readme
            and "Reference only; no native `SKILL.md` loading assumed" in readme
        ),
        "broad brand disclaimer": all(
            all(brand in localized for brand in ("OpenClaw", "Hermes Agent", "Cursor", "Aider"))
            for localized in (readme, readme_zh, readme_ja, readme_ko)
        ),
        "installer syntax": installer_syntax_ok(ROOT / "scripts/install.sh"),
        "workflow yaml": workflow_yaml_parses(ROOT / ".github/workflows/validate.yml"),
        "local markdown links": not broken_links,
        "prompt x-ray positioning": "Prompt X-Ray" in content and "Prompt X-Ray" in readme,
        "prompt x-ray report": (
            "Prompt X-Ray Report" in content
            and "Prompt X-Ray Report" in readme
            and "Smallest useful repair" in content
        ),
        "animated demo replay": (
            "@keyframes appear" in demo_svg
            and "animated terminal demo" in demo_svg
            and '"version":2' in demo_cast
            and "assets/demo.cast" in readme
        ),
        "coverage table": (
            "Current Expected-Behavior Run" in coverage
            and "Covered for all 20 cases" in coverage
            and "ordinary writing" in coverage.lower()
            and "Prompt X-Ray coverage notes" in readme
            and "worked examples and coverage notes" in readme
            and "not as a third-party benchmark" in readme
        ),
        "no cold-start homepage copy": not any(
            re.search(
                r"focused sprint|feedback-driven|real users|maintainer-authored|self-evaluation snapshot",
                localized,
                re.IGNORECASE,
            )
            for localized in (readme, readme_zh, readme_ja, readme_ko)
        ),
        "security private reporting": (
            "private vulnerability reporting" in security and "do not paste" in security
        ),
        "localized readme headings": (
            not english_h2.search(readme_ja) and not english_h2.search(readme_ko)
        ),
        "expected-behavior case count": case_count_ok,
        "expected-behavior case structure": case_structure_ok,
        "expected-behavior run notes": (
            all(f"[{n:02d}]" in run_notes for n in range(1, 21))
            and "not an automated benchmark" in run_notes
            and "third-party evaluation" in run_notes
        ),
    }

    failed = [name_ for name_, passed in checks.items() if not passed]

    for check_name, passed in checks.items():
        print(f"{'PASS' if passed else 'FAIL'} {check_name}")

    if broken_links:
        for link in broken_links:
            print(f"  broken-link: {link}", file=sys.stderr)

    if failed:
        print(f"Validation failed: {', '.join(failed)}", file=sys.stderr)
        return 1

    print(f"checks={len(checks)} passed={len(checks)} failed=0")
    return 0


if __name__ == "__main__":
    sys.exit(main())
