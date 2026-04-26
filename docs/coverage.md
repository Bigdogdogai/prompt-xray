# Prompt X-Ray Coverage

Coverage of expected behaviors across 15 prompt failure patterns. Authored and self-evaluated by the maintainer; not a benchmark, not third-party verified, and not model-comparable. Use this as worked examples, not as a quality claim.

## Coverage Areas

The coverage set maps 15 prompt-engineering cases in [tests/prompt-xray](../tests/prompt-xray):

| Coverage area | Cases | Expected behavior |
| --- | --- | --- |
| Missing or weak output format | 04, 07, 10, 13 | Flag the output contract as weak and propose a minimal schema, table, or report shape. |
| Injection-style risk | 02, 05, 11 | Treat pasted or external instructions as untrusted data and avoid following them. |
| Hidden reasoning leakage | 03, 14 | Remove hidden chain-of-thought or private scratchpad requests. |
| Over-broad trigger or task scope | 06, 09, 15 | Narrow the task or avoid triggering for ordinary writing. |
| Local agent workflow risk | 08, 10, 12 | Add file scope, command boundaries, verification, and remaining-risk reporting. |

## Current v1.0.1 Author Self-Evaluation

Snapshot: [2026-04-26 author self-eval](../tests/prompt-xray-runs/2026-04-26-author-self-eval.md)

| Coverage check | Current observation |
| --- | --- |
| Expected mode identified for prompt-engineering cases | Covered in the self-eval snapshot |
| Ordinary writing false-trigger avoided | Covered in the self-eval snapshot |
| Injection-style risks identified | Covered in the self-eval snapshot |
| Hidden reasoning leakage identified | Covered in the self-eval snapshot |
| Missing or weak output-format issues identified | Covered in the self-eval snapshot |
| Local agent workflow risks identified | Covered in the self-eval snapshot |
| Smallest useful repair recorded for every case | Covered for all 15 cases |

## How To Reproduce

1. Install the skill for your target agent with `bash scripts/install.sh <platform>`.
2. Start a fresh agent session.
3. For each file in `tests/prompt-xray/*.md`, ask the agent to analyze the `Input Prompt` using Prompt X-Ray.
4. Compare the result with the `Expected X-Ray Findings` and `Minimal Repair` sections.
5. Record observed behavior in `tests/prompt-xray-runs/<date>-author-self-eval.md`.

## What This Coverage Is Good For

- Making the skill's safety boundaries visible.
- Checking that the trigger is narrow enough.
- Verifying that outputs stay concrete and testable.
- Preventing future README or `SKILL.md` edits from weakening injection handling, hidden-reasoning handling, or local workflow rules.

## What It Is Not

- It is not an automated model benchmark.
- It is not third-party verified.
- It is not a scoring system.
- It is not a claim that every agent will produce identical text.
- It is not a replacement for production eval tools such as promptfoo, LangSmith, PromptLayer, or a custom CI evaluation suite.
