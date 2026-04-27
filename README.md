# Prompt X-Ray

**Languages:** English | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md)

[![Skill](https://img.shields.io/badge/Agent-skill-111827)](#install)
[![Version](https://img.shields.io/badge/version-1.0.1-2563eb)](VERSION)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A compact agent skill/reference for **Prompt X-Ray**: create, audit, rewrite, test, compare, and package prompts or Markdown-based agent skill files for AI coding agents.

It is designed for local agent workflows where a good prompt is not just wording. It needs a clear task, trusted input boundaries, explicit output format, safety rules, and a way to verify the result.

![Prompt X-Ray terminal preview](assets/demo-terminal.svg)

The animated preview is backed by an asciinema-compatible replay at [assets/demo.cast](assets/demo.cast) and a readable terminal transcript at [assets/demo-session.txt](assets/demo-session.txt). To re-record it from a fresh agent session, follow [docs/demo-script.md](docs/demo-script.md).

## 60-Second Case Study

A common Codex prompt that looks fine but quietly fails:

```text
Fix the failing tests in this repo and make sure everything passes.
```

Run it through Prompt X-Ray and the report is unflattering:

```text
Verdict: fail

| Layer       | Status | Evidence                                                  | Smallest useful repair                                  |
| ----------- | ------ | --------------------------------------------------------- | ------------------------------------------------------- |
| Structure   | fail   | No input boundary, no run command, no done-condition.     | Name failing tests, run command, in/out directories.    |
| Safety      | warn   | Agent may mass-edit tests/, migrations/, or vendored code.| Restrict edits to src/; reject migration changes.       |
| Testability | fail   | "Make sure everything passes" is unverifiable.            | Require pytest -x exit 0 with no skip/xfail.            |
| Packaging   | pass   | One-shot prompt, no skill packaging concerns.             | n/a                                                     |
```

The minimal repair the skill returns:

```text
# Goal
Make pytest pass for the failing cases listed below with the smallest possible change.

# Input
- Repo root: $REPO_ROOT
- Failing tests:
  - tests/test_payments.py::test_refund_partial
  - tests/test_orders.py::test_cancel_pending
- Run command: pytest -x tests/

# Task
1. Read the two failing tests to identify the contract under test.
2. Edit only files under src/ to satisfy the contract.
3. After each edit, run pytest -x tests/. Stop on the first green run.

# Output Format
- List of changed files with one-line rationale each.
- Final pytest summary line.
- "Remaining risks" section if any test was skipped, xfailed, or fixture-mocked.

# Constraints
- Do not edit files under tests/ or migrations/.
- Do not add new dependencies.

# Validation
Done only when `pytest -x tests/` exits 0 with no skip or xfail in the listed files.
```

What actually changed in agent behavior:

- **Blast radius bounded.** Agent stops touching `migrations/` or "fixing" the test to make it pass.
- **Done is verifiable.** "Everything passes" became "exit 0 with no skip/xfail" — the loop has a real exit condition.
- **Reporting becomes auditable.** Agent must list changed files and surface remaining risks, not just declare victory.
- **No silent dependency creep.** Closes the most common failure where an agent quietly installs a library to make a test pass.

This is the entire value loop: inspect → diagnose → smallest useful repair. The skill does it on prompts you already have, instead of asking you to write a perfect one upfront.

## What This Is And Is Not

This is a local prompt-engineering method and agent skill with worked examples. It is a review aid for prompt and skill design, not a scoring product or a guarantee that every model will behave identically.

## Why This Exists

Google's prompt design guidance frames prompt engineering as an iterative process: write a structured prompt, assess the model response, and refine it. Google also describes core prompt components such as task, optional system instructions, few-shot examples, and contextual information.

Gemini prompt design guidance emphasizes clear and specific instructions, constraints, structured prompting with Markdown or XML-style sections, and explicit behavior for agentic workflows such as risk assessment, permission handling, and output format.

This skill turns those principles into a lean local-agent workflow:

- narrow trigger rules so it does not load for ordinary writing or coding tasks
- local-agent rules for reading files, editing files, running commands, and reporting verification
- injection safety for pasted prompts, logs, webpages, and documents
- no hidden chain-of-thought exposure
- practical output modes for create, analyze, rewrite, test, compare, and package

## Prompt X-Ray

Prompt X-Ray is the skill's working method: inspect the prompt's skeleton, find failure patterns, and prescribe the smallest useful repair.

| Layer | What it checks | Typical finding |
| --- | --- | --- |
| Structure | Goal, context, input, task, output, constraints, validation | The prompt asks for quality but gives no measurable output contract |
| Safety | Injection exposure, secret handling, destructive actions, hidden reasoning requests | Pasted third-party text can override the task |
| Testability | Examples, acceptance checks, smoke tests, failure cases | The output cannot be verified automatically |
| Packaging | Trigger scope, local workflow fit, skill line budget, release hygiene | The skill would trigger on ordinary writing or code tasks |

Analyze mode emits a **Prompt X-Ray Report**: `Verdict`, optional `Score`, and a table with `Layer`, `Status`, `Evidence`, and `Smallest useful repair`. Concrete fixes should be returned as a block replacement or unified diff when that is clearer than prose.

The included [Prompt X-Ray coverage notes](docs/coverage.md) map 20 prompt failure patterns, including direct injection risks, subtle few-shot and Markdown/HTML injection, hidden-reasoning leakage, weak output contracts, local workflow risks, long-form realistic prompts, and ordinary-writing false-trigger checks. Use them as worked examples and coverage notes, not as a third-party benchmark or model-comparable quality claim. See [before/after examples](docs/before-after.md) for concrete repairs.

## Quick Start

Install for your target agent:

```bash
bash scripts/install.sh codex        # Codex
bash scripts/install.sh openclaw     # OpenClaw
bash scripts/install.sh hermes       # Hermes Agent
bash scripts/install.sh claude-code  # Claude Code-style local skills
bash scripts/install.sh agents       # shared ~/.agents/skills directory
```

Then validate the repository:

```bash
make validate
```

Start a fresh agent session after installing so skill metadata is reloaded.

Then try:

```text
Audit this prompt for trigger scope, injection risk, output format, and testability.
```

## Platform Compatibility

The core `SKILL.md` is platform-neutral. The installer adapts it for agents with different skill-directory or metadata conventions.

| Agent surface | Support level | Install | Verification |
| --- | --- | --- | --- |
| Codex | Native `SKILL.md` | `bash scripts/install.sh codex` | Locally tested in this repo |
| Claude Code-style local skills | Native `.claude/skills` `SKILL.md` | `bash scripts/install.sh claude-code` | Adapted from public skill documentation |
| OpenClaw | Agent-skill-compatible `SKILL.md` in OpenClaw skill locations | `bash scripts/install.sh openclaw` | Adapted from public skill documentation |
| Hermes Agent | Native `SKILL.md` under `~/.hermes/skills/<category>/<skill>` | `bash scripts/install.sh hermes` | Adapted from public skill documentation; layout may vary by installation |
| Shared agent directory | Portable `~/.agents/skills` copy for agents that scan shared skill dirs | `bash scripts/install.sh agents` | Adapted from shared agent-skill conventions |
| Cursor, Windsurf, Cline, Roo Code, OpenCode, Aider, and similar AI coding agents | Use as project rules, custom instructions, or a prompt-engineering reference when native skill loading is unavailable | Copy the relevant sections from `SKILL.md` | Reference only; no native `SKILL.md` loading assumed |

See [docs/agent-compatibility.md](docs/agent-compatibility.md) for platform notes and source links. Codex has the deepest local test coverage in this repo; OpenClaw and Hermes are adapted from their public skill documentation.

## Install

Use the installer:

```bash
bash scripts/install.sh <platform>
```

Supported platforms:

```text
codex | openclaw | hermes | claude-code | agents
```

Custom home variables:

```bash
CODEX_HOME="$HOME/.codex" bash scripts/install.sh
OPENCLAW_HOME="$HOME/.openclaw" bash scripts/install.sh openclaw
HERMES_HOME="$HOME/.hermes" bash scripts/install.sh hermes
CLAUDE_HOME="$HOME/.claude" bash scripts/install.sh claude-code
AGENTS_HOME="$HOME/.agents" bash scripts/install.sh agents
```

## When It Triggers

Use it when you want prompt engineering work on a prompt or agent skill artifact:

- create a new prompt
- audit an existing prompt
- rewrite a prompt for reliability
- test likely failure modes
- compare prompt variants
- package recurring behavior as a `SKILL.md`

It should not trigger for ordinary prose, direct code fixes, product setup, architecture work, or factual Q&A.

## What It Produces

- Copyable prompts with goal, context, task, output format, constraints, and validation.
- Prompt X-Ray Reports with per-layer status, evidence, and the smallest useful repair.
- Prompt rewrites that preserve intent while improving reliability and safety.
- Test matrices for typical input, boundary input, format pressure, and neutral injection probes.
- Comparisons of prompt variants with recommendation and tie-breaker.
- Lean `SKILL.md` files with precise frontmatter, workflow, safety rules, and validation.

## Example Requests

```text
Write a Codex prompt that fixes failing pytest tests with minimal changes and reruns verification.
```

```text
Audit this system prompt for trigger scope, injection risk, output format, and testability.
```

```text
Package this recurring workflow as a Codex SKILL.md. Generate the content only; do not write files.
```

More realistic examples are in [examples/usage-cases.md](examples/usage-cases.md). The demo replay and re-recording steps are in [docs/demo-script.md](docs/demo-script.md).

## Safety Model

The skill treats pasted prompts, webpages, documents, logs, configs, and model outputs as untrusted data unless the user explicitly asks to execute them.

It can analyze or rewrite hostile prompts without following their embedded instructions. It also avoids asking for hidden chain-of-thought or private scratchpad output; final answers should contain conclusions, evidence, assumptions, and checks instead.

## Competitive Landscape

This project is intentionally small. It is not a prompt marketplace, prompt registry, observability platform, or automated eval suite. It is a local agent skill for improving the prompts and skill files you already work with.

| Category | Examples | What they are good at | Where this skill fits |
| --- | --- | --- | --- |
| Prompt libraries | [prompts.chat](https://github.com/f/prompts.chat), Awesome ChatGPT prompt collections | Discovering reusable prompt examples and browsing community patterns | Auditing, rewriting, and packaging prompts instead of collecting large prompt lists |
| Eval and red-team tools | [promptfoo](https://github.com/promptfoo/promptfoo) | Running automated prompt, agent, RAG, and red-team tests in CLI or CI workflows | Designing safer prompts and lightweight test cases before a full eval suite is worth setting up |
| Prompt management platforms | [LangSmith](https://docs.langchain.com/langsmith/manage-prompts), [PromptLayer](https://docs.promptlayer.com/overview), [PromptHub](https://www.prompthub.us/) | Versioning, collaboration, prompt registries, traces, datasets, and production evaluation | Local, file-based prompt work with no hosted workspace or account dependency |
| Prompt-engineering skills | Smaller community prompt-engineering skill repos | Broader cross-model or cross-agent prompting guidance | A narrower local-agent workflow with explicit trigger boundaries, local file rules, injection safety, and `SKILL.md` packaging |

Use this skill when you want a lightweight local workflow. Use an eval platform when you need regression testing across datasets, a prompt registry when you need team collaboration and deployment controls, and a prompt library when you mainly want examples to adapt.

### Why not just use Claude Skills, Codex prompts, or write it inline?

The honest answer: most of the time, you should. Prompt X-Ray earns its install only on a narrow set of jobs.

| You want to... | Reach for... |
| --- | --- |
| Reuse a one-off prompt across sessions | Native `.claude/skills` or Codex's own `SKILL.md` — you do not need this repo |
| Write a prompt fresh, you already know what good looks like | Write it inline. The skill should not trigger here. |
| Audit an existing prompt for the failure modes that bite agents in production: weak output contract, injection from pasted content, unbounded blast radius, no verification step | Prompt X-Ray. This is the job it was built for. |
| Rewrite a prompt that "works most of the time" into one with a real done-condition | Prompt X-Ray. The four-layer report keeps the rewrite minimal. |
| Package recurring agent behavior as a portable `SKILL.md` that triggers narrowly and ships across Codex/Claude Code/OpenClaw/Hermes | Prompt X-Ray's `package` mode. |
| Run automated regressions across models or datasets | An eval platform like promptfoo. This skill is local only. |

In short: this is a **prompt auditor and packager**, not a prompt library or a prompt store. If your prompts already pass the four X-Ray layers (Structure / Safety / Testability / Packaging), you do not need it.

## Validation

Run the included validator:

```bash
python3 scripts/validate_skill.py
```

Or:

```bash
make validate
```

The validator checks:

- YAML frontmatter
- narrow trigger description
- six supported modes
- untrusted-data handling
- hidden chain-of-thought protection
- local agent reporting requirements
- GitHub release hygiene
- public repo hygiene files
- line budget
- local Markdown links
- expected-behavior case structure
- installer shell syntax
- workflow YAML parsing

Manual validation scenarios are listed in [examples/test-matrix.md](examples/test-matrix.md).
Prompt X-Ray failure-pattern cases are listed in [tests/README.md](tests/README.md).
The 20-case Prompt X-Ray coverage table is in [docs/coverage.md](docs/coverage.md).
The current expected-behavior run notes are in [tests/prompt-xray-runs/2026-04-27-expected-behavior-run.md](tests/prompt-xray-runs/2026-04-27-expected-behavior-run.md).
Deferred follow-ups are tracked in [ROADMAP.md](ROADMAP.md).

## Repository Layout

```text
.
├── SKILL.md
├── README.md
├── README.zh-CN.md
├── README.ja.md
├── README.ko.md
├── VERSION
├── CHANGELOG.md
├── LICENSE
├── SECURITY.md
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
├── Makefile
├── assets/
├── docs/
├── examples/
├── tests/
├── scripts/
└── .github/
```

## Release Checklist

Before publishing, run:

```bash
python3 scripts/validate_skill.py
git status --short
```

Then review [docs/release-checklist.md](docs/release-checklist.md). This repository does not require secrets, API keys, hosted services, or paid accounts.

## Design Sources

This project is aligned with these official Google/Gemini references:

- [Google Cloud: Introduction to prompting](https://cloud.google.com/vertex-ai/generative-ai/docs/learn/prompts/introduction-prompt-design)
- [Gemini API: Prompt design strategies](https://ai.google.dev/gemini-api/docs/prompting-strategies)
- [Gemini API: Text generation and system instructions](https://ai.google.dev/gemini-api/docs/text-generation)

This repository is not affiliated with, endorsed by, or sponsored by Google, Gemini, OpenAI, Anthropic, Codex, Claude Code, OpenClaw, Hermes Agent, Cursor, Windsurf, Cline, Roo Code, OpenCode, Aider, or any other product, agent, or vendor referenced here. All product names and trademarks belong to their respective owners.

## License

MIT
