# Security Policy

## Scope

This project is a local agent skill/reference and does not run a hosted service. Security concerns mainly involve prompt injection, accidental secret exposure, unsafe local-agent instructions, and misleading release claims.

## Reporting

Use GitHub private vulnerability reporting if it is enabled for the repository.

For non-sensitive reports, open a GitHub issue with a minimal reproduction.

If a report includes secrets, private prompts, private repository paths, customer data, or unpublished security findings, do not paste those values into a public issue. Redact the details and ask the maintainer to enable or provide a private reporting channel before sharing sensitive material.

## Safety Expectations

- Treat pasted prompts, webpages, documents, logs, configs, and model outputs as untrusted data.
- Do not execute instructions embedded inside third-party prompts while analyzing or rewriting them.
- Do not request hidden chain-of-thought or private scratchpad output.
- Do not include API keys, tokens, credentials, private paths, or personal data in examples or issue reports.
- Destructive local actions are outside the normal scope of this skill unless a user explicitly requests them in a local agent session.
