#!/usr/bin/env bash
# sync-to-claude.sh — Pousse les skills, agents et hooks utilisateur vers le profil local Claude.
#
#   skills/  → CLAUDE_SKILLS_PATH  (~/.claude/skills)
#   agents/  → CLAUDE_AGENTS_PATH  (~/.claude/agents)
#   hooks/user/ → CLAUDE_HOOKS_PATH (~/.claude/hooks)
#               + entrée PreToolUse dans ~/.claude/settings.json
#
# Usage : ./scripts/sync-to-claude.sh
# Env   : CLAUDE_SKILLS_PATH  (defaut : ~/.claude/skills)
#         CLAUDE_AGENTS_PATH  (defaut : ~/.claude/agents)
#         CLAUDE_HOOKS_PATH   (defaut : ~/.claude/hooks)

set -euo pipefail

CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"
SKILLS_DEST="${CLAUDE_SKILLS_PATH:-$CLAUDE_DIR/skills}"
AGENTS_DEST="${CLAUDE_AGENTS_PATH:-$CLAUDE_DIR/agents}"
HOOKS_DEST="${CLAUDE_HOOKS_PATH:-$CLAUDE_DIR/hooks}"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_ROOT="$REPO_ROOT/skills"
AGENTS_ROOT="$REPO_ROOT/agents"
HOOKS_ROOT="$REPO_ROOT/hooks/user"

# ---------------------------------------------------------------------------
# Skills
# ---------------------------------------------------------------------------
echo "=== Skills ==="
echo "Source      : $SKILLS_ROOT"
echo "Destination : $SKILLS_DEST"
echo ""

if [ ! -d "$SKILLS_DEST" ]; then
  mkdir -p "$SKILLS_DEST"
  echo "Dossier cree : $SKILLS_DEST"
fi

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

if [ "$SYNCED_SKILLS" -eq 0 ]; then
  echo "Aucun skill trouve dans $SKILLS_ROOT."
  exit 1
fi
echo "$SYNCED_SKILLS skill(s) pousses."

# ---------------------------------------------------------------------------
# Agents
# ---------------------------------------------------------------------------
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
  cp "$agent_md" "$AGENTS_DEST/$agent_name.md"
  echo "OK $agent_name"
  SYNCED_AGENTS=$((SYNCED_AGENTS + 1))
done < <(find "$AGENTS_ROOT" -name "AGENT.md" 2>/dev/null)

if [ "$SYNCED_AGENTS" -eq 0 ]; then
  echo "Aucun agent trouve (normal si agents/ est vide)."
else
  echo "$SYNCED_AGENTS agent(s) pousses."
fi

# ---------------------------------------------------------------------------
# Hooks utilisateur
# ---------------------------------------------------------------------------
echo ""
echo "=== Hooks utilisateur ==="
echo "Source      : $HOOKS_ROOT"
echo "Destination : $HOOKS_DEST"
echo "Settings    : $SETTINGS_FILE"
echo ""

if [ ! -d "$HOOKS_DEST" ]; then
  mkdir -p "$HOOKS_DEST"
  echo "Dossier cree : $HOOKS_DEST"
fi

SYNCED_HOOKS=0
for hook_file in "$HOOKS_ROOT"/*.sh; do
  [ -f "$hook_file" ] || continue
  hook_name=$(basename "$hook_file")
  cp "$hook_file" "$HOOKS_DEST/$hook_name"
  chmod +x "$HOOKS_DEST/$hook_name"
  echo "OK $hook_name"
  SYNCED_HOOKS=$((SYNCED_HOOKS + 1))
done

if [ "$SYNCED_HOOKS" -eq 0 ]; then
  echo "Aucun hook utilisateur trouve dans $HOOKS_ROOT."
else
  echo "$SYNCED_HOOKS hook(s) pousses."

  # Fusionner les entrees PreToolUse dans ~/.claude/settings.json
  echo ""
  echo "Mise a jour de $SETTINGS_FILE ..."
  node - "$SETTINGS_FILE" "$HOOKS_DEST" <<'NODE'
const fs   = require('fs');
const path = require('path');

const settingsFile = process.argv[1];
const hooksDir     = process.argv[2];

// Lire les settings existants (creer si absent)
let settings = {};
if (fs.existsSync(settingsFile)) {
  try { settings = JSON.parse(fs.readFileSync(settingsFile, 'utf8')); }
  catch (e) { console.error('Erreur lecture settings.json :', e.message); process.exit(1); }
}

if (!settings.hooks)                settings.hooks = {};
if (!settings.hooks.PreToolUse)     settings.hooks.PreToolUse = [];

// Pour chaque hook dans hooks/user/, ajouter une entree PreToolUse si absente
const hookFiles = fs.readdirSync(hooksDir).filter(f => f.endsWith('.sh'));
let added = 0;
for (const hookFile of hookFiles) {
  const hookPath = path.join(hooksDir, hookFile).replace(/\\/g, '/');
  const cmd      = `bash "${hookPath}"`;

  const alreadyRegistered = settings.hooks.PreToolUse.some(
    entry => entry.hooks && entry.hooks.some(h => h.command === cmd)
  );

  if (!alreadyRegistered) {
    settings.hooks.PreToolUse.push({
      matcher: 'Bash',
      hooks: [{ type: 'command', command: cmd }]
    });
    console.log('  + Hook enregistre : ' + hookFile);
    added++;
  } else {
    console.log('  = Deja enregistre : ' + hookFile);
  }
}

if (added > 0) {
  fs.writeFileSync(settingsFile, JSON.stringify(settings, null, 2) + '\n');
  console.log('settings.json mis a jour.');
} else {
  console.log('Aucune modification necessaire.');
}
NODE
fi

# ---------------------------------------------------------------------------
echo ""
echo "Sync termine."
