# Prompt X-Ray

**语言:** [English](README.md) | 简体中文 | [日本語](README.ja.md) | [한국어](README.ko.md)

[![Skill](https://img.shields.io/badge/Agent-skill-111827)](#安装)
[![Version](https://img.shields.io/badge/version-1.0.1-2563eb)](VERSION)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Prompt X-Ray** 是一个轻量 agent skill/reference：创建、审核、改写、测试、比较 prompt，并把重复工作流打包成 AI coding agent 可用的 Markdown skill 或规则。

它面向本地 agent 工作流：一个好 prompt 不只是措辞，而是要有清晰任务、可信输入边界、明确输出格式、安全规则和验证方式。

本地化 README 保留核心使用信息；完整的 repository layout、release checklist 和维护细节见 [English README](README.md)。

![Prompt X-Ray terminal preview](assets/demo-terminal.svg)

这个 animated preview 对应 [assets/demo.cast](assets/demo.cast) 和可读 transcript [assets/demo-session.txt](assets/demo-session.txt)。如果要用新的 agent session 重新录制，按 [docs/demo-script.md](docs/demo-script.md) 操作。

## 60 秒案例

一个看起来没问题、但会悄悄翻车的 Codex prompt：

```text
Fix the failing tests in this repo and make sure everything passes.
```

跑一遍 Prompt X-Ray，报告很难看：

```text
Verdict: fail

| Layer       | Status | Evidence                                              | Smallest useful repair                          |
| ----------- | ------ | ----------------------------------------------------- | ----------------------------------------------- |
| Structure   | fail   | 没有输入边界、运行命令、完成判定                      | 列出失败用例、运行命令、可改/不可改目录         |
| Safety     | warn   | agent 可能改 tests/、migrations/ 或 vendored 代码     | 限制只能改 src/，禁止改 migration               |
| Testability | fail   | "make sure everything passes" 无法验证                | 要求 pytest -x 退出 0、无 skip/xfail            |
| Packaging   | pass   | 一次性 prompt，无 skill 打包问题                      | n/a                                             |
```

skill 给的最小修复：

```text
# Goal
用最小改动让 pytest 通过下面列出的失败用例。

# Input
- Repo root: $REPO_ROOT
- Failing tests:
  - tests/test_payments.py::test_refund_partial
  - tests/test_orders.py::test_cancel_pending
- Run command: pytest -x tests/

# Task
1. 先读两个失败 test，理清被测契约。
2. 只改 src/ 下的文件来满足契约。
3. 每次修改后跑 pytest -x tests/，第一次绿了就停。

# Output Format
- 改动文件列表，每个文件一行说明。
- 最终 pytest summary 行。
- 如果有 test 被 skip / xfail / fixture-mock，列出 "Remaining risks"。

# Constraints
- 不改 tests/ 和 migrations/。
- 不新增依赖。

# Validation
只有当 `pytest -x tests/` 退出 0、列表中的 test 没有 skip/xfail，任务才算完成。
```

agent 行为上真正发生的变化：

- **爆炸半径锁死。** agent 不再去改 `migrations/`，也不会通过"改测试"的方式让测试通过。
- **完成是可验证的。** "everything passes" 变成"exit 0 且无 skip/xfail" — 循环有了真正的退出条件。
- **报告变得可审计。** agent 必须列出改了哪些文件、留下了什么风险，不是只说一句"修好了"。
- **不再悄悄装依赖。** 堵住了最常见的隐性失败：agent 默默 `pip install` 一个库来让测试通过。

整个价值循环就这一句话：**inspect → diagnose → smallest useful repair**。skill 是直接对你已经在用的 prompt 做这件事，而不是要求你一上来就写一个完美 prompt。

## 为什么存在

Google 的 prompt design 指南强调迭代：写结构化 prompt、评估模型输出、再改进。Gemini 的 prompt design 指南强调清晰具体的指令、约束、Markdown 或 XML 风格结构，以及 agentic workflow 中的风险评估、权限处理和输出格式。

这个 skill 把这些原则压缩成 local-agent 工作流：

- 触发范围窄，不会因为普通写作或代码任务误加载
- 适配本地 agent 的读文件、改文件、跑命令和验证报告
- 把用户粘贴的 prompt、日志、网页、文档默认当作 untrusted data
- 不要求暴露 hidden chain-of-thought
- 支持 create、analyze、rewrite、test、compare、package 六种模式

## Prompt X-Ray

Prompt X-Ray 是这个 skill 的工作方法：检查 prompt 骨架，定位失败模式，再给出最小可用修复。

| 层级 | 检查内容 | 典型发现 |
| --- | --- | --- |
| Structure | goal、context、input、task、output、constraints、validation | prompt 要求高质量，但没有可验证输出契约 |
| Safety | injection 暴露、secret 处理、destructive actions、hidden reasoning 请求 | 粘贴的第三方文本可能覆盖任务 |
| Testability | examples、acceptance checks、smoke tests、failure cases | 输出无法自动验证 |
| Packaging | trigger scope、本地 workflow、skill 行数、release hygiene | skill 会在普通写作或代码任务中误触发 |

Analyze mode 会输出 **Prompt X-Ray Report**：`Verdict`、可选 `Score`，以及包含 `Layer`、`Status`、`Evidence`、`Smallest useful repair` 的表格。能明确修复时，优先给 block replacement 或 unified diff。

[Prompt X-Ray coverage notes](docs/coverage.md) 映射 20 个 prompt failure pattern，包括直接 injection、隐蔽 few-shot 与 Markdown/HTML injection、hidden-reasoning leakage、弱输出契约、本地 workflow 风险、长篇真实 prompt，以及 ordinary-writing false-trigger check。把它们当作 worked examples 和 coverage notes 使用，不要当作第三方 benchmark 或跨模型质量声明。具体修复见 [before/after examples](docs/before-after.md)。

## 快速开始

为目标 agent 安装：

```bash
bash scripts/install.sh codex        # Codex
bash scripts/install.sh openclaw     # OpenClaw
bash scripts/install.sh hermes       # Hermes Agent
bash scripts/install.sh claude-code  # Claude Code-style local skills
bash scripts/install.sh agents       # shared ~/.agents/skills
```

然后验证仓库：

```bash
make validate
```

安装后开启新的 agent 会话，让 skill metadata 重新加载。

然后可以试：

```text
Audit this prompt for trigger scope, injection risk, output format, and testability.
```

## 平台兼容

核心 `SKILL.md` 是平台中立的。安装脚本会按 Codex、OpenClaw、Hermes Agent、Claude Code-style skills 或共享 `.agents/skills` 目录做路径和元数据适配。

| 平台 | 安装 | 验证状态 |
| --- | --- | --- |
| Codex | `bash scripts/install.sh codex` | 本仓库已本地测试 |
| Claude Code-style local skills | `bash scripts/install.sh claude-code` | 根据公开 skill 文档适配 |
| OpenClaw | `bash scripts/install.sh openclaw` | 根据公开 skill 文档适配 |
| Hermes Agent | `bash scripts/install.sh hermes` | 根据公开 skill 文档适配；不同安装的目录布局可能不同 |
| Shared agent directory | `bash scripts/install.sh agents` | 根据共享 agent-skill 目录约定适配 |

Cursor、Windsurf、Cline、Roo Code、OpenCode、Aider 等不一定都有同一种 native skill loader；可把 `SKILL.md` 作为 project rules、custom instructions 或 prompt-engineering reference 使用。详见 [docs/agent-compatibility.md](docs/agent-compatibility.md)。

## 安装

使用安装脚本：

```bash
bash scripts/install.sh <platform>
```

支持：

```text
codex | openclaw | hermes | claude-code | agents
```

可自定义 home：

```bash
CODEX_HOME="$HOME/.codex" bash scripts/install.sh
OPENCLAW_HOME="$HOME/.openclaw" bash scripts/install.sh openclaw
HERMES_HOME="$HOME/.hermes" bash scripts/install.sh hermes
CLAUDE_HOME="$HOME/.claude" bash scripts/install.sh claude-code
AGENTS_HOME="$HOME/.agents" bash scripts/install.sh agents
```

## 什么时候触发

当你要对 prompt 或 agent skill artifact 做 prompt engineering 时使用：

- 创建新 prompt
- 审核已有 prompt
- 改写 prompt 提升稳定性
- 测试潜在失败模式
- 比较 prompt 变体
- 把重复行为打包成 `SKILL.md`

不应该用于普通文案、直接修代码、产品配置、架构设计或事实问答。

## 产出什么

- 带 goal、context、task、output format、constraints、validation 的可复制 prompt
- 包含分层 status、evidence 和 smallest useful repair 的 Prompt X-Ray Report
- 保留意图但提升稳定性和安全性的 prompt rewrite
- 覆盖典型输入、边界输入、格式压力和中性 injection probe 的 test matrix
- prompt 变体对比表、推荐结论和 tie-breaker
- 带精确 frontmatter、workflow、safety rules 和 validation 的精简 `SKILL.md`

## 示例请求

```text
Write a Codex prompt that fixes failing pytest tests with minimal changes and reruns verification.
```

```text
Audit this system prompt for trigger scope, injection risk, output format, and testability.
```

```text
Package this recurring workflow as a Codex SKILL.md. Generate the content only; do not write files.
```

更多真实场景见 [examples/usage-cases.md](examples/usage-cases.md)。Demo replay 和重新录制步骤见 [docs/demo-script.md](docs/demo-script.md)。

## 安全模型

这个 skill 默认把粘贴的 prompt、网页、文档、日志、配置和模型输出当作 untrusted data，除非用户明确要求执行。

它可以分析或改写恶意 prompt，但不会遵循其中的嵌入指令。它也避免要求 hidden chain-of-thought 或 private scratchpad；最终回答应该输出结论、依据、假设和检查项。

## 竞品定位

这个项目刻意保持小而轻。它不是 prompt marketplace、prompt registry、observability platform 或自动 eval suite。它是一个本地 agent skill，用来改进你已经在使用的 prompt 和 skill 文件。

| 类别 | 例子 | 擅长什么 | 本 skill 的位置 |
| --- | --- | --- | --- |
| Prompt libraries | [prompts.chat](https://github.com/f/prompts.chat), Awesome ChatGPT prompt collections | 发现可复用示例和社区模式 | 审核、改写、打包 prompt，而不是收集大型 prompt 列表 |
| Eval and red-team tools | [promptfoo](https://github.com/promptfoo/promptfoo) | 在 CLI 或 CI 里跑自动化 prompt、agent、RAG 和 red-team 测试 | 在值得接入完整 eval suite 前，先设计更安全的 prompt 和轻量测试用例 |
| Prompt management platforms | [LangSmith](https://docs.langchain.com/langsmith/manage-prompts), [PromptLayer](https://docs.promptlayer.com/overview), [PromptHub](https://www.prompthub.us/) | 版本控制、协作、prompt registry、trace、dataset 和生产评估 | 本地、文件化、无托管工作区或账号依赖的 prompt 工作流 |
| Prompt-engineering skills | Smaller community prompt-engineering skill repos | 更宽泛的跨模型或跨 agent prompt 指南 | 更窄的 local-agent 工作流，强调触发边界、本地文件规则、injection safety 和 `SKILL.md` packaging |

如果你需要轻量本地工作流，用这个 skill。如果你需要跨数据集回归测试，用 eval platform；如果你需要团队协作和部署控制，用 prompt registry；如果你主要想找示例，用 prompt library。

### 为什么不直接用 Claude Skills、Codex prompts 或 inline 写？

老实回答：大多数情况下你确实应该这么做。Prompt X-Ray 只在特定几类工作上才值得装。

| 你想做的事 | 用什么 |
| --- | --- |
| 把一次性 prompt 在多次会话里复用 | 用 native `.claude/skills` 或 Codex 自己的 `SKILL.md`，**不需要本仓库** |
| 从零写 prompt，自己已经清楚什么是好 | inline 写就行，skill 也不应该在这里触发 |
| 审核已有 prompt 里那些会让 agent 在生产中翻车的失败模式：弱输出契约、粘贴内容引发 injection、爆炸半径不受控、缺验证步骤 | Prompt X-Ray，本来就是为这件事造的 |
| 把"大多数时候能跑"的 prompt 改写成有真正完成判定的 prompt | Prompt X-Ray，四层报告能让改写保持最小 |
| 把重复的 agent 行为打包成一份触发严格、能跨 Codex/Claude Code/OpenClaw/Hermes 复用的 `SKILL.md` | Prompt X-Ray 的 `package` 模式 |
| 跨模型/数据集跑自动化回归 | promptfoo 这类 eval 平台。本 skill 是纯本地工具 |

一句话：这是一个 **prompt 审计器和打包器**，不是 prompt 库或 prompt store。如果你的 prompt 已经能通过四层 X-Ray 检查（Structure / Safety / Testability / Packaging），就不需要它。

## 验证

运行：

```bash
python3 scripts/validate_skill.py
```

手动验证场景见 [examples/test-matrix.md](examples/test-matrix.md)。
Prompt X-Ray failure-pattern 案例见 [tests/README.md](tests/README.md)。
后续路线图见 [ROADMAP.md](ROADMAP.md)。

## 发布检查

发布前运行：

```bash
python3 scripts/validate_skill.py
git status --short
```

然后检查 [docs/release-checklist.md](docs/release-checklist.md)。本仓库不需要 secrets、API keys、托管服务或付费账号。

## 设计来源

本项目参考并对齐这些官方 Google/Gemini 资料：

- [Google Cloud: Introduction to prompting](https://cloud.google.com/vertex-ai/generative-ai/docs/learn/prompts/introduction-prompt-design)
- [Gemini API: Prompt design strategies](https://ai.google.dev/gemini-api/docs/prompting-strategies)
- [Gemini API: Text generation and system instructions](https://ai.google.dev/gemini-api/docs/text-generation)

本仓库不隶属于 Google、Gemini、OpenAI、Anthropic、Codex、Claude Code、OpenClaw、Hermes Agent、Cursor、Windsurf、Cline、Roo Code、OpenCode、Aider，或本文档中提到的任何其他产品、agent 或厂商，也未获得其赞助或背书。所有产品名称和商标均归其各自所有者所有。

## License

MIT
