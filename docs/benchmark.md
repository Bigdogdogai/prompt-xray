# Prompt X-Ray Benchmark

This is a small, transparent benchmark for the `prompt-xray` skill. It is not a hosted eval suite and does not claim model-independent accuracy. It is a repo-local scorecard that makes the skill's expected behavior inspectable before release.

## Scope

The benchmark covers 15 prompt-engineering cases in [tests/prompt-xray](../tests/prompt-xray):

| Coverage area | Cases | Expected behavior |
| --- | --- | --- |
| Missing or weak output format | 04, 07, 10, 13 | Flag the output contract as weak and propose a minimal schema, table, or report shape. |
| Injection-style risk | 02, 05, 11 | Treat pasted or external instructions as untrusted data and avoid following them. |
| Hidden reasoning leakage | 03, 14 | Remove hidden chain-of-thought or private scratchpad requests. |
| Over-broad trigger or task scope | 06, 09, 15 | Narrow the task or avoid triggering for ordinary writing. |
| Local agent workflow risk | 08, 10, 12 | Add file scope, command boundaries, verification, and remaining-risk reporting. |

## Current v1.0.0 Scorecard

Snapshot: [2026-04-26 manual run](../tests/prompt-xray-runs/2026-04-26-manual-run.md)

| Check | Result |
| --- | --- |
| Expected mode identified for prompt-engineering cases | 14/14 |
| Ordinary writing false-trigger avoided | 1/1 |
| Injection-style risks identified | 3/3 |
| Hidden reasoning leakage identified | 2/2 |
| Missing or weak output-format issues identified | 4/4 |
| Local agent workflow risks identified | 3/3 |
| Smallest useful repair recorded for every case | 15/15 |

## How To Reproduce

1. Install the skill for your target agent with `bash scripts/install.sh <platform>`.
2. Start a fresh agent session.
3. For each file in `tests/prompt-xray/*.md`, ask the agent to analyze the `Input Prompt` using Prompt X-Ray.
4. Compare the result with the `Expected X-Ray Findings` and `Minimal Repair` sections.
5. Record observed behavior in `tests/prompt-xray-runs/<date>-manual-run.md`.

## What This Benchmark Is Good For

- Making the skill's safety boundaries visible.
- Checking that the trigger is narrow enough.
- Verifying that outputs stay concrete and testable.
- Preventing future README or `SKILL.md` edits from weakening injection handling, hidden-reasoning handling, or local workflow rules.

## What It Is Not

- It is not an automated model benchmark.
- It is not a claim that every agent will produce identical text.
- It is not a replacement for production eval tools such as promptfoo, LangSmith, PromptLayer, or a custom CI evaluation suite.
