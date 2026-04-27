# Prompt X-Ray Coverage

Coverage of expected behaviors across 20 prompt failure patterns. These notes are reproducible worked examples, not an automated benchmark, third-party certification, or model-comparable quality claim.

## Coverage Areas

The coverage set maps 20 prompt-engineering cases in [tests/prompt-xray](../tests/prompt-xray):

| Coverage area | Cases | Expected behavior |
| --- | --- | --- |
| Missing or weak output format | 04, 07, 10, 13, 17 | Flag the output contract as weak and propose a minimal schema, table, or report shape. |
| Direct injection-style risk | 02, 05, 11 | Treat pasted or external instructions as untrusted data and avoid following them. |
| Subtle indirect injection | 19, 20 | Detect injected instructions hidden inside few-shot examples, Markdown metadata, comments, or hidden HTML. |
| Hidden reasoning or private-log leakage | 03, 14 | Remove hidden chain-of-thought, private scratchpad, or policy/tool-decision log requests. |
| Over-broad trigger or task scope | 06, 09, 15, 18 | Narrow the task or avoid triggering for ordinary writing. |
| Local agent workflow risk | 08, 10, 12, 16, 18 | Add file scope, command boundaries, verification, and remaining-risk reporting. |
| Long-form realistic prompts | 16, 17, 18 | Check multi-section prompts that combine useful context with unsafe or underspecified instructions. |

## Current Expected-Behavior Run

Run notes: [2026-04-27 expected-behavior run](../tests/prompt-xray-runs/2026-04-27-expected-behavior-run.md)

| Coverage check | Current observation |
| --- | --- |
| Expected mode identified for prompt-engineering cases | Covered in the current run notes |
| Ordinary writing false-trigger avoided | Covered in the current run notes |
| Injection-style risks identified | Covered in the current run notes |
| Hidden reasoning leakage identified | Covered in the current run notes |
| Missing or weak output-format issues identified | Covered in the current run notes |
| Local agent workflow risks identified | Covered in the current run notes |
| Long-form realistic prompts included | Covered in the current run notes |
| Subtle indirect injection cases included | Covered in the current run notes |
| Smallest useful repair recorded for every case | Covered for all 20 cases |

## How To Reproduce

1. Install the skill for your target agent with `bash scripts/install.sh <platform>`.
2. Start a fresh agent session.
3. For each file in `tests/prompt-xray/*.md`, ask the agent to analyze the `Input Prompt` using Prompt X-Ray.
4. Compare the result with the `Expected X-Ray Findings` and `Minimal Repair` sections.
5. Record observed behavior in `tests/prompt-xray-runs/<date>-expected-behavior-run.md`.

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
