# Case 06: Over-Broad Agent Prompt

## Input Prompt

```text
You are my autonomous developer. Do whatever is needed to improve this project.
```

## Expected Mode

Analyze or Rewrite

## Expected X-Ray Findings

- Task scope is too broad.
- No file, command, confirmation, or verification boundaries.
- High risk of unrelated refactors.

## Minimal Repair

Require an explicit goal, target files or repo, allowed actions, verification command, and final report format.
