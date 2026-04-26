# Changelog

All notable changes to this project are documented here.

## Unreleased

### Added

- Added three long-form realistic prompt cases for bug fixing, customer research, and skill packaging workflows.
- Added two subtle indirect injection cases covering few-shot example injection and Markdown/HTML hidden-content injection.
- Added `scripts/validate_cases.rb` to validate expected-behavior case structure, numbering, modes, findings, and long-form case length.

### Changed

- Revised Case 14 to distinguish private scratchpad/policy-log leakage from the simpler hidden chain-of-thought request in Case 03.
- Expanded coverage notes and tests README from 15 to 20 cases.

## 1.0.1 - 2026-04-27

### Changed

- Reframed the repository's expected-behavior evidence from benchmark/scorecard language to coverage/self-evaluation language.
- Renamed `docs/benchmark.md` to `docs/coverage.md`.
- Renamed the 2026-04-26 manual run snapshot to an author self-evaluation snapshot.
- Added a README section clarifying that Prompt X-Ray coverage is not an automated benchmark, score, third-party certification, or model-comparable quality claim.
- Moved deferred launch follow-ups from `docs/` to root `ROADMAP.md`.

## 1.0.0 - 2026-04-26

### Added

- Initial public `prompt-xray` portable agent skill/reference.
- Prompt X-Ray positioning: structure, safety, testability, and packaging checks.
- Prompt X-Ray Report output shape for Analyze mode.
- Multilingual README entry points for English, Simplified Chinese, Japanese, and Korean.
- Prompt X-Ray expected-behavior set with 15 failure-pattern cases.
- Manual Prompt X-Ray run snapshot for all 15 expected-behavior cases.
- Public 15-case Prompt X-Ray coverage notes.
- Animated terminal replay backed by an asciinema-compatible `assets/demo.cast` file and readable transcript.
- Before/after examples showing diagnosis and minimal repair.
- Six supported modes: create, analyze, rewrite, test, compare, and package.
- Injection-safety rules for pasted prompts, webpages, documents, logs, configs, and model outputs.
- Hidden chain-of-thought protection and concise rationale guidance.
- Codex local workflow rules for reading files, editing files, running verification, and reporting results.
- Ruby validation script for frontmatter schema, trigger scope, safety, local links, installer syntax, release hygiene, and line budget.
- GitHub-ready README, examples, release checklist, security policy, code of conduct, contribution guide, and issue/PR templates.
- Installer script and GitHub Actions validation workflow.
- `make validate` entrypoint and Ruby 3.0/3.3 CI matrix.
- Multi-agent install targets for Codex, Claude Code-style local skills, OpenClaw, Hermes Agent, and shared `~/.agents/skills`.
- Localized Japanese and Korean README headings to avoid partial-translation presentation.

### Security

- External prompts are treated as untrusted data during analysis, rewrite, test, and compare workflows.
- Sensitive values found in pasted content should be redacted by role, such as `[API_KEY]`.
