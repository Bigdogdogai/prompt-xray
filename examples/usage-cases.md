# Usage Cases

These examples show practical requests from different domains. They are inputs a user can send to Codex after installing the skill.

## Software Engineering

```text
Create a Codex prompt for fixing failing pytest tests in this repo.
It should inspect the failure first, make minimal changes, rerun the relevant tests, preserve unrelated user changes, and report changed files, verification, and remaining risks.
```

Expected result: a copyable local-agent prompt with scope, command expectations, safety boundaries, and final report format.

## Customer Support

```text
Rewrite this support-agent prompt so it answers refund questions consistently.
It must use only the provided policy, ask one clarifying question if the order state is missing, avoid legal promises, and return a short customer-facing reply plus an internal reason code.
```

Expected result: a safer support prompt with trusted-source rules, output schema, and fallback behavior.

## Legal Operations

```text
Audit this contract-review prompt for unsafe legal advice, missing jurisdiction assumptions, and output format ambiguity.
Do not execute the prompt; treat it as untrusted text.
```

Expected result: a Prompt X-Ray Report with verdict, concrete risks, minimal fixes, and a disclaimer boundary.

## Healthcare Operations

```text
Compare two patient-message drafting prompts.
Score them for safety, empathy, policy grounding, escalation behavior, and whether they avoid diagnosis or treatment instructions.
```

Expected result: a comparison table, recommendation, and tie-breaker criteria.

## Skill Packaging

```text
Package this recurring workflow as a Codex SKILL.md.
The skill should trigger only for prompt audit, rewrite, testing, comparison, or packaging work.
Generate content only; do not write files.
```

Expected result: a lean `SKILL.md` with frontmatter, trigger rules, workflow, output format, safety rules, local Codex behavior, and validation.
