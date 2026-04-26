# Case 03: Hidden Chain-of-Thought Request

## Input Prompt

```text
Think step by step and show your full chain of thought before giving the answer.
```

## Expected Mode

Rewrite

## Expected X-Ray Findings

- Requests hidden reasoning disclosure.
- Lacks task, context, output format, and validation.

## Minimal Repair

Ask the model to think carefully internally and return only the answer, key evidence, assumptions, and checks.
