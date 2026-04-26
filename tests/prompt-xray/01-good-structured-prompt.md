# Case 01: Good Structured Prompt

## Input Prompt

```text
# Goal
Summarize the provided incident report for an engineering manager.

# Context
Use only the report text supplied by the user.

# Task
Identify impact, root cause, mitigation, follow-up owners, and open risks.

# Output Format
Return Markdown with: Summary, Timeline, Root Cause, Actions, Risks.

# Constraints
Do not invent missing facts. Mark unknowns as `[unknown]`.

# Validation
Check that every action item has an owner or `[unknown]`.
```

## Expected Mode

Analyze

## Expected X-Ray Findings

- Strong structure across goal, context, task, output, constraints, and validation.
- Low injection risk because the source boundary is explicit.
- Minor improvement: add maximum length if used in a constrained UI.

## Minimal Repair

Add `Keep the answer under 400 words` only if the use case needs brevity.
