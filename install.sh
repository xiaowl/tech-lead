#!/usr/bin/env bash
# Install skills from this skillset into an agent's skills directory.
#
# Usage:
#   ./install.sh                # auto-detect installed agents
#   ./install.sh claude         # install only for Claude Code
#   ./install.sh codex          # install only for Codex CLI
#   ./install.sh /path/to/dir   # install into an arbitrary skills directory
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"

# agent name -> skills directory
agent_dir() {
  case "$1" in
    claude)   echo "$HOME/.claude/skills" ;;
    codex)    echo "$HOME/.codex/skills" ;;
    opencode) echo "$HOME/.config/opencode/skills" ;;
    goose)    echo "$HOME/.config/goose/skills" ;;
    *)        return 1 ;;
  esac
}

install_to() {
  local dest="$1"
  mkdir -p "$dest"
  local installed=()
  for skill_dir in "$SKILLS_SRC"/*/; do
    local name
    name="$(basename "$skill_dir")"
    rm -rf "$dest/$name"
    cp -R "$skill_dir" "$dest/$name"
    installed+=("$name")
  done
  printf 'Installed to %s: %s\n' "$dest" "${installed[*]}"
}

if [[ $# -eq 0 ]]; then
  # auto-detect
  found=0
  for agent in claude codex opencode goose; do
    if command -v "$agent" &>/dev/null || [[ -d "$(agent_dir "$agent")" ]]; then
      install_to "$(agent_dir "$agent")"
      found=1
    fi
  done
  if [[ $found -eq 0 ]]; then
    echo "No known agent detected. Usage: $0 <claude|codex|opencode|goose|/path/to/skills-dir>" >&2
    exit 1
  fi
else
  target="$1"
  if dir="$(agent_dir "$target" 2>/dev/null)"; then
    install_to "$dir"
  elif [[ -d "$target" ]] || [[ "$target" = /* ]]; then
    install_to "$target"
  else
    echo "Unknown agent or directory: $target" >&2
    echo "Usage: $0 <claude|codex|opencode|goose|/path/to/skills-dir>" >&2
    exit 1
  fi
fi
