#!/usr/bin/env bash
# sync-to-claude.sh — Pousse les skills de ce repo vers le profil local Claude.
# Detecte automatiquement les skills via la presence de SKILL.md (recherche recursive sous skills/).
# Le nom du skill dans le profil = nom du dossier skill (sans le chemin thematique).
#
# Usage : ./scripts/sync-to-claude.sh
# Env   : CLAUDE_SKILLS_PATH  (defaut : /mnt/skills/user)

set -euo pipefail

SKILLS_DEST="${CLAUDE_SKILLS_PATH:-/mnt/skills/user}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_ROOT="$REPO_ROOT/skills"

if [ ! -d "$SKILLS_DEST" ]; then
  echo "Destination introuvable : $SKILLS_DEST"
  echo "Definir CLAUDE_SKILLS_PATH vers le dossier de skills Claude."
  exit 1
fi

echo "Source      : $SKILLS_ROOT"
echo "Destination : $SKILLS_DEST"
echo ""

SYNCED=0
while IFS= read -r skill_md; do
  skill_dir=$(dirname "$skill_md")
  skill_name=$(basename "$skill_dir")

  # Copie propre : supprime la destination puis recopie (equivalent rsync --delete)
  rm -rf "$SKILLS_DEST/$skill_name"
  cp -rp "$skill_dir" "$SKILLS_DEST/$skill_name"
  # Supprimer les .DS_Store eventuels
  find "$SKILLS_DEST/$skill_name" -name '.DS_Store' -delete 2>/dev/null || true
  echo "OK $skill_name"
  SYNCED=$((SYNCED + 1))
done < <(find "$SKILLS_ROOT" -name "SKILL.md" 2>/dev/null)

echo ""
if [ "$SYNCED" -eq 0 ]; then
  echo "Aucun skill trouve dans $SKILLS_ROOT. Verifier la structure du repo."
  exit 1
fi

echo "Sync termine ($SYNCED skills pousses vers $SKILLS_DEST)."
