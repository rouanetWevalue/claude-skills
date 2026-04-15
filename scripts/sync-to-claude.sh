#!/usr/bin/env bash
# sync-to-claude.sh — Pousse les skills et agents de ce repo vers le profil local Claude.
# Skills  : detectes via SKILL.md (recursif sous skills/)  → CLAUDE_SKILLS_PATH
# Agents  : detectes via AGENT.md (recursif sous agents/)  → CLAUDE_AGENTS_PATH
#
# Usage : ./scripts/sync-to-claude.sh
# Env   : CLAUDE_SKILLS_PATH  (defaut : ~/.claude/skills)
#         CLAUDE_AGENTS_PATH  (defaut : ~/.claude/agents)

set -euo pipefail

SKILLS_DEST="${CLAUDE_SKILLS_PATH:-$HOME/.claude/skills}"
AGENTS_DEST="${CLAUDE_AGENTS_PATH:-$HOME/.claude/agents}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_ROOT="$REPO_ROOT/skills"
AGENTS_ROOT="$REPO_ROOT/agents"

# --- Skills ---

if [ ! -d "$SKILLS_DEST" ]; then
  echo "Destination skills introuvable : $SKILLS_DEST"
  echo "Definir CLAUDE_SKILLS_PATH ou creer le dossier ~/.claude/skills"
  exit 1
fi

echo "=== Skills ==="
echo "Source      : $SKILLS_ROOT"
echo "Destination : $SKILLS_DEST"
echo ""

SYNCED_SKILLS=0
while IFS= read -r skill_md; do
  skill_dir=$(dirname "$skill_md")
  skill_name=$(basename "$skill_dir")
  rm -rf "$SKILLS_DEST/$skill_name"
  cp -rp "$skill_dir" "$SKILLS_DEST/$skill_name"
  find "$SKILLS_DEST/$skill_name" -name '.DS_Store' -delete 2>/dev/null || true
  echo "OK $skill_name"
  SYNCED_SKILLS=$((SYNCED_SKILLS + 1))
done < <(find "$SKILLS_ROOT" -name "SKILL.md" 2>/dev/null)

echo ""
if [ "$SYNCED_SKILLS" -eq 0 ]; then
  echo "Aucun skill trouve dans $SKILLS_ROOT."
  exit 1
fi
echo "$SYNCED_SKILLS skill(s) pousses vers $SKILLS_DEST."

# --- Agents ---

echo ""
echo "=== Agents ==="
echo "Source      : $AGENTS_ROOT"
echo "Destination : $AGENTS_DEST"
echo ""

if [ ! -d "$AGENTS_DEST" ]; then
  mkdir -p "$AGENTS_DEST"
  echo "Dossier cree : $AGENTS_DEST"
fi

SYNCED_AGENTS=0
while IFS= read -r agent_md; do
  agent_dir=$(dirname "$agent_md")
  agent_name=$(basename "$agent_dir")
  # Les agents sont synchronises en tant que fichier unique AGENT.md → <agent-name>.md
  cp "$agent_md" "$AGENTS_DEST/$agent_name.md"
  echo "OK $agent_name"
  SYNCED_AGENTS=$((SYNCED_AGENTS + 1))
done < <(find "$AGENTS_ROOT" -name "AGENT.md" 2>/dev/null)

echo ""
if [ "$SYNCED_AGENTS" -eq 0 ]; then
  echo "Aucun agent trouve dans $AGENTS_ROOT (normal si agents/ est vide)."
else
  echo "$SYNCED_AGENTS agent(s) pousses vers $AGENTS_DEST."
fi

echo ""
echo "Sync termine."
