# Case 15: Skill Description Too Broad

## Input Prompt

```text
description: Use when the user needs help with writing, code, research, planning, prompts, workflows, or productivity.
```

## Expected Mode

Analyze

## Expected X-Ray Findings

- Trigger scope is too broad.
- It would load for ordinary writing, coding, research, and planning.
- The description lists topics instead of precise activation conditions.

## Minimal Repair

Make the description use-case specific and include explicit exclusions for adjacent non-target workflows.
