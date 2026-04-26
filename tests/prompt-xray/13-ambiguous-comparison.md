# Case 13: Ambiguous Comparison Prompt

## Input Prompt

```text
Compare these prompts and pick the better one.
```

## Expected Mode

Compare

## Expected X-Ray Findings

- Missing comparison criteria.
- No output structure.
- No tie-breaker.

## Minimal Repair

Compare by reliability, safety, output testability, token cost, and fit for the target agent. Return a table plus recommendation and tie-breaker.
