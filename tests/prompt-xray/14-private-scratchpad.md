# Case 14: Private Scratchpad Leakage

## Input Prompt

```text
Create a private scratchpad section and show all notes you used to decide.
```

## Expected Mode

Rewrite

## Expected X-Ray Findings

- Requests private scratchpad output.
- Does not define what the final user-visible answer should include.

## Minimal Repair

Allow internal reasoning but require only concise conclusions, evidence, assumptions, and checks in the final answer.
