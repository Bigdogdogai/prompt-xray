# Case 10: No Verification Path

## Input Prompt

```text
Fix the issue and tell me when it is done.
```

## Expected Mode

Rewrite

## Expected X-Ray Findings

- Missing success criteria.
- Missing test, lint, build, or smoke-check command.
- No changed-files or remaining-risks report.

## Minimal Repair

Ask the agent to inspect the failure, make minimal changes, run the most relevant verification command, and report changed files, verification, and remaining risks.
