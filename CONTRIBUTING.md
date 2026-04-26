# Contributing

Thanks for improving `prompt-xray`. Keep contributions small, testable, and focused on portable local-agent prompt engineering.

## Good Contributions

- Clearer trigger boundaries that reduce false activation.
- Better prompt audit, rewrite, test, compare, or packaging behavior.
- Safer handling of pasted prompts, logs, webpages, configs, and model outputs.
- Realistic examples that show Codex local workflows.
- Validation improvements that catch release or safety regressions.

## Before Opening a PR

Run:

```bash
make validate
```

Check that:

- `SKILL.md` stays lean and easy to load.
- The frontmatter `description` says when to use the skill, not a long process summary.
- Pasted external content remains untrusted data.
- No prompt asks for hidden chain-of-thought or private scratchpad output.
- No local-only paths, secrets, private usernames, or unofficial brand endorsement claims are introduced.

## Style

- Use concise English in repo docs.
- Prefer operational rules over motivational language.
- Keep examples copyable.
- Avoid broad claims like "best" or "guaranteed".
