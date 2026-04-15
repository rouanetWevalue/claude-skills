#!/usr/bin/env bash
# sync-to-claude.sh — Pousse les skills de ce repo vers le profil local Claude.
# Seuls les dossiers contenant un SKILL.md sont copiés (detection automatique).
#
# Usage : ./scripts/sync-to-claude.sh
# Env   : CLAUDE_SKILLS_PATH  (defaut : /mnt/skills/user)

set -euo pipefail
shopt -s nullglob

SKILLS_DEST="${CLAUDE_SKILLS_PATH:-/mnt/skills/user}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ ! -d "$SKILLS_DEST" ]; then
  echo "Destination introuvable : $SKILLS_DEST"
  echo "Definir CLAUDE_SKILLS_PATH vers le dossier de skills Claude."
  exit 1
fi

echo "Source      : $REPO_ROOT"
echo "Destination : $SKILLS_DEST"
echo ""

SYNCED=0
for skill_dir in "$REPO_ROOT"/*/; do
  skill_name=$(basename "$skill_dir")

  # Ne copier que les dossiers qui contiennent un SKILL.md
  if [ ! -f "$skill_dir/SKILL.md" ]; then
    continue
  fi

  # Copie propre : supprime la destination puis recopie (equivalent rsync --delete)
  rm -rf "$SKILLS_DEST/$skill_name"
  cp -rp "$skill_dir" "$SKILLS_DEST/$skill_name"
  # Supprimer les .DS_Store eventuels
  find "$SKILLS_DEST/$skill_name" -name '.DS_Store' -delete 2>/dev/null || true
  echo "OK $skill_name"
  SYNCED=$((SYNCED + 1))
done

echo ""
if [ "$SYNCED" -eq 0 ]; then
  echo "Aucun skill trouve dans $REPO_ROOT. Verifier la structure du repo."
  exit 1
fi

echo "Sync termine ($SYNCED skills pousses vers $SKILLS_DEST)."
