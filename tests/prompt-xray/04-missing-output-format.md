# Case 04: Missing Output Format

## Input Prompt

```text
Analyze these customer complaints and tell me what matters.
```

## Expected Mode

Rewrite

## Expected X-Ray Findings

- Missing output format.
- No prioritization criteria.
- No source boundary or handling for missing context.

## Minimal Repair

Require a table with `Theme`, `Evidence`, `Frequency`, `Severity`, and `Recommended Action`; tell the model to use only provided complaints and mark unknowns.
