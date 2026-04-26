# prompt-xray

**Languages:** [English](README.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | 한국어

[![Skill](https://img.shields.io/badge/Agent-skill-111827)](#설치)
[![Version](https://img.shields.io/badge/version-1.0.1-2563eb)](VERSION)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

`prompt-xray`는 실용적인 **Prompt X-Ray**를 위한 작고 가벼운 agent skill/reference입니다. 프롬프트 생성, 감사, 재작성, 테스트, 비교, 그리고 AI coding agent용 Markdown skill/rules 패키징을 지원합니다.

이 skill은 로컬 agent workflow에 맞춰져 있습니다. 좋은 프롬프트에는 명확한 task, 신뢰 가능한 input boundary, 명시적인 output format, safety rules, validation method가 필요합니다.

이 localized README는 핵심 사용 정보만 담고 있습니다. 전체 repository layout, release checklist, maintenance details는 [English README](README.md)를 참고하세요.

![prompt-xray terminal preview](assets/demo-terminal.svg)

이 animated preview는 [assets/demo.cast](assets/demo.cast) 및 readable transcript [assets/demo-session.txt](assets/demo-session.txt)에 대응합니다. 새로운 agent session에서 다시 녹화하려면 [docs/demo-script.md](docs/demo-script.md)를 참고하세요.

## 이 프로젝트가 필요한 이유

Google prompt design guidance는 structured prompt를 작성하고, model response를 평가하고, 다시 개선하는 반복 과정을 강조합니다. Gemini guidance는 명확하고 구체적인 지시, constraints, Markdown 또는 XML-style sections, 그리고 agentic workflow의 risk assessment, permission handling, output format을 강조합니다.

이 skill은 그 원칙을 local-agent workflow로 압축합니다.

- ordinary writing 또는 coding task에서 잘못 trigger되지 않도록 좁은 trigger scope
- local agent를 위한 file reading, editing, command running, verification reporting rules
- pasted prompts, logs, webpages, documents를 untrusted data로 다루는 injection safety
- hidden chain-of-thought를 요구하지 않는 design
- create, analyze, rewrite, test, compare, package 6가지 mode

## Prompt X-Ray

Prompt X-Ray는 이 skill의 작업 방식입니다. prompt의 뼈대를 확인하고, 실패 패턴을 찾고, 가장 작은 유효 수정안을 제시합니다.

Analyze mode는 **Prompt X-Ray Report**를 반환합니다. `Verdict`, 필요한 경우 `Score`, 그리고 `Layer`, `Status`, `Evidence`, `Smallest useful repair` 표를 포함합니다. 수정이 명확하면 prose보다 block replacement 또는 unified diff를 우선합니다.

포함된 [Prompt X-Ray coverage notes](docs/coverage.md)는 15개의 일반적인 prompt failure pattern을 다룹니다. 3개의 injection-style risk, 2개의 hidden-reasoning leakage case, 4개의 missing / weak output-format specification, 1개의 ordinary-writing false-trigger check를 포함합니다. 이것은 maintainer-authored worked examples와 self-evaluation snapshot이며 third-party benchmark 또는 model-comparable quality claim이 아닙니다. 구체적인 수정 예시는 [before/after examples](docs/before-after.md)를 참고하세요.

## 빠른 시작

Target agent에 설치합니다.

```bash
bash scripts/install.sh codex
bash scripts/install.sh openclaw
bash scripts/install.sh hermes
bash scripts/install.sh claude-code
bash scripts/install.sh agents
```

Repository를 검증합니다.

```bash
make validate
```

설치 후 fresh agent session을 시작해 skill metadata를 다시 로드하세요.

Try:

```text
Audit this prompt for trigger scope, injection risk, output format, and testability.
```

## 플랫폼 호환성

핵심 `SKILL.md`는 platform-neutral입니다. Installer는 Codex, OpenClaw, Hermes Agent, Claude Code-style skills, shared `.agents/skills` directory에 맞게 배치합니다.

| Platform | Install | Verification |
| --- | --- | --- |
| Codex | `bash scripts/install.sh codex` | 이 repo에서 local test 완료 |
| Claude Code-style local skills | `bash scripts/install.sh claude-code` | 공개 skill documentation 기반 적용 |
| OpenClaw | `bash scripts/install.sh openclaw` | 공개 skill documentation 기반 적용 |
| Hermes Agent | `bash scripts/install.sh hermes` | 공개 skill documentation 기반 적용. installation에 따라 layout이 다를 수 있음 |
| Shared agent directory | `bash scripts/install.sh agents` | shared agent-skill convention 기반 적용 |

Cursor, Windsurf, Cline, Roo Code, OpenCode, Aider 등은 native skill loading이 없을 수 있으므로 project rules, custom instructions, prompt-engineering reference로 사용합니다. 자세한 내용은 [docs/agent-compatibility.md](docs/agent-compatibility.md)를 참고하세요.

## 설치

Installer를 사용합니다.

```bash
bash scripts/install.sh <platform>
```

Supported platforms:

```text
codex | openclaw | hermes | claude-code | agents
```

Custom home:

```bash
CODEX_HOME="$HOME/.codex" bash scripts/install.sh
OPENCLAW_HOME="$HOME/.openclaw" bash scripts/install.sh openclaw
HERMES_HOME="$HOME/.hermes" bash scripts/install.sh hermes
CLAUDE_HOME="$HOME/.claude" bash scripts/install.sh claude-code
AGENTS_HOME="$HOME/.agents" bash scripts/install.sh agents
```

## 언제 사용하는가

prompt 또는 agent skill artifact에 대한 prompt engineering 작업에 사용합니다.

- create a new prompt
- audit an existing prompt
- rewrite a prompt for reliability
- test likely failure modes
- compare prompt variants
- package recurring behavior as a `SKILL.md`

ordinary prose, direct code fix, product setup, architecture work, factual Q&A에는 trigger되지 않아야 합니다.

## 출력 내용

- Copyable prompts with goal, context, task, output format, constraints, and validation
- Prompt X-Ray Reports with per-layer status, evidence, and smallest useful repair
- Prompt rewrites that preserve intent while improving reliability and safety
- Test matrices for typical input, boundary input, format pressure, and neutral injection probes
- Comparisons of prompt variants with recommendation and tie-breaker
- Lean `SKILL.md` files with precise frontmatter, workflow, safety rules, and validation

## 예시

```text
Write a Codex prompt that fixes failing pytest tests with minimal changes and reruns verification.
```

```text
Audit this system prompt for trigger scope, injection risk, output format, and testability.
```

```text
Package this recurring workflow as a Codex SKILL.md. Generate the content only; do not write files.
```

더 많은 사용 예시는 [examples/usage-cases.md](examples/usage-cases.md)를 참고하세요. Demo replay 및 re-recording steps는 [docs/demo-script.md](docs/demo-script.md)에 있습니다.

## 안전 모델

이 skill은 사용자가 명시적으로 실행을 요청하지 않는 한 pasted prompts, webpages, documents, logs, configs, model outputs를 untrusted data로 취급합니다.

악의적인 prompt를 분석하거나 재작성할 수 있지만 그 안의 embedded instructions를 따르지는 않습니다. hidden chain-of-thought 또는 private scratchpad output을 요구하지 않으며, 최종 답변에는 conclusions, evidence, assumptions, checks가 포함되어야 합니다.

## 경쟁 제품과의 위치

이 프로젝트는 의도적으로 작게 유지됩니다. prompt marketplace, prompt registry, observability platform, automated eval suite가 아닙니다. 이미 사용하는 prompts와 skill files를 개선하기 위한 local agent skill입니다.

가벼운 local workflow가 필요하면 이 skill을 사용하세요. dataset regression testing이 필요하면 eval platform, 팀 협업과 deployment controls가 필요하면 prompt registry, 참고 예시가 필요하면 prompt library가 더 적합합니다.

## 검증

```bash
ruby scripts/validate_skill.rb
```

Manual scenarios: [examples/test-matrix.md](examples/test-matrix.md).
Prompt X-Ray cases: [tests/README.md](tests/README.md).
Roadmap: [ROADMAP.md](ROADMAP.md).

## 설계 출처

- [Google Cloud: Introduction to prompting](https://cloud.google.com/vertex-ai/generative-ai/docs/learn/prompts/introduction-prompt-design)
- [Gemini API: Prompt design strategies](https://ai.google.dev/gemini-api/docs/prompting-strategies)
- [Gemini API: Text generation and system instructions](https://ai.google.dev/gemini-api/docs/text-generation)

이 repository는 Google, Gemini, OpenAI, Anthropic, Codex, Claude Code, OpenClaw, Hermes Agent, Cursor, Windsurf, Cline, Roo Code, OpenCode, Aider 또는 여기서 언급되는 다른 product, agent, vendor와 제휴, 승인, 후원 관계가 없습니다. 모든 product names와 trademarks는 각 소유자에게 귀속됩니다.

## License

MIT
