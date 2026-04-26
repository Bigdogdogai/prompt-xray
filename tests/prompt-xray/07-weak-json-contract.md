# Case 07: Weak JSON Contract

## Input Prompt

```text
Return JSON about this article.
```

## Expected Mode

Rewrite

## Expected X-Ray Findings

- Output format says JSON but gives no schema.
- No invalid or missing-field behavior.
- No source boundary.

## Minimal Repair

Define required keys, value types, nullable fields, and rule: return only valid JSON with no Markdown wrapper.
