#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
platform="${1:-codex}"
skill_slug="prompt-xray"

usage() {
  cat <<'USAGE'
Usage: bash scripts/install.sh [platform]

Platforms:
  codex        Install to $CODEX_HOME/skills/prompt-xray
  claude-code  Install to $CLAUDE_HOME/skills/prompt-xray
  openclaw     Install to $OPENCLAW_HOME/skills/prompt-xray
  openclaw-agent Install to $AGENTS_HOME/skills/prompt-xray
  hermes       Install to $HERMES_HOME/skills/prompt-engineering/prompt-xray
  agents       Install to $AGENTS_HOME/skills/prompt-xray

Environment:
  CODEX_HOME defaults to ~/.codex
  CLAUDE_HOME defaults to ~/.claude
  OPENCLAW_HOME defaults to ~/.openclaw
  HERMES_HOME defaults to ~/.hermes
  AGENTS_HOME defaults to ~/.agents
USAGE
}

case "$platform" in
  codex)
    target_dir="${CODEX_HOME:-$HOME/.codex}/skills/$skill_slug"
    ;;
  claude-code|claude)
    target_dir="${CLAUDE_HOME:-$HOME/.claude}/skills/$skill_slug"
    ;;
  openclaw)
    target_dir="${OPENCLAW_HOME:-$HOME/.openclaw}/skills/$skill_slug"
    ;;
  openclaw-agent|agents)
    target_dir="${AGENTS_HOME:-$HOME/.agents}/skills/$skill_slug"
    ;;
  hermes)
    target_dir="${HERMES_HOME:-$HOME/.hermes}/skills/prompt-engineering/$skill_slug"
    ;;
  -h|--help|help)
    usage
    exit 0
    ;;
  *)
    echo "Unknown platform: $platform" >&2
    usage >&2
    exit 2
    ;;
esac

mkdir -p "$target_dir"
cp "$repo_dir/SKILL.md" "$target_dir/SKILL.md"

echo "Installed Prompt X-Ray (prompt-xray) for $platform to $target_dir/SKILL.md"
echo "Start a fresh agent session if your client does not hot-reload skills."
echo "If the skill does not load after restart, see docs/agent-compatibility.md."
