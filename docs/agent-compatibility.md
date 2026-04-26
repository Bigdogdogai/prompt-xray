# Agent Compatibility

`prompt-xray` is a portable `SKILL.md` package. It is most tested in Codex locally, but the skill body avoids Codex-only behavior and can be installed or copied into other AI coding agents and Markdown skill-compatible agents.

## Native Skill Targets

| Agent | Install command | Target path | Notes |
| --- | --- | --- | --- |
| Codex | `bash scripts/install.sh codex` | `~/.codex/skills/prompt-xray/SKILL.md` | Primary local test target for this repository. |
| Claude Code | `bash scripts/install.sh claude-code` | `~/.claude/skills/prompt-xray/SKILL.md` | Claude Code documents personal skills at `~/.claude/skills/<skill-name>/SKILL.md`. |
| OpenClaw | `bash scripts/install.sh openclaw` | `~/.openclaw/skills/prompt-xray/SKILL.md` | OpenClaw documents agent-skill-compatible folders with `SKILL.md` and also supports shared `~/.agents/skills`. |
| Shared agents | `bash scripts/install.sh agents` | `~/.agents/skills/prompt-xray/SKILL.md` | Useful for agents that read the common agent-skill-style directory. |
| Hermes Agent | `bash scripts/install.sh hermes` | `~/.hermes/skills/prompt-engineering/prompt-xray/SKILL.md` | Hermes documents category-based skill folders under `~/.hermes/skills/` and standardized `SKILL.md` metadata. Treat this as a local-user layout unless your Hermes installation specifies another skills root. |

## Rule / Instruction Targets

For Cursor, Windsurf, Cline, Roo Code, OpenCode, Aider, and similar agents, native `SKILL.md` loading varies. When no native skill loader exists, use `SKILL.md` as a project rule or custom-instructions reference:

- Copy the trigger boundary, Prompt X-Ray Report, safety rules, and local-agent rules.
- Keep the name `prompt-xray` for discoverability.
- Do not copy installer paths into agents that do not use skill directories.
- Keep pasted prompts, webpages, logs, and tool outputs as untrusted data.

## Source Notes

- [OpenClaw skills documentation](https://docs.openclaw.ai/tools/skills) describes skill folders, locations, and precedence: `~/.openclaw/skills`, `~/.agents/skills`, workspace `.agents/skills`, and workspace `skills`.
- [Claude Code skills documentation](https://code.claude.com/docs/en/skills) documents personal skills at `~/.claude/skills/<skill-name>/SKILL.md` and project skills at `.claude/skills/<skill-name>/SKILL.md`.
- [Hermes Agent skills documentation](https://hermes-agent.nousresearch.com/docs/user-guide/features/skills/) documents `~/.hermes/skills/`, category-based `~/.hermes/skills/<category>/<skill-name>/SKILL.md` packages, and a `SKILL.md` format with `name`, `description`, optional `version`, and `metadata.hermes`.

## Caution

Do not claim official endorsement from any agent vendor. This repository ships a portable Markdown skill; each agent's actual loading behavior is controlled by that agent's current documentation and local configuration.
