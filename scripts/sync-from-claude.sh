#!/usr/bin/env bash
# sync-from-claude.sh — Resynchronise les skills personnels depuis Claude vers ce repo.
# Les skills organisation sont exclus (source : CLAUDE_ORG_PATH).
# Si un skill existe deja dans skills/ (quel que soit son chemin thematique), il est mis a jour en place.
# Sinon, il est cree dans skills/ (plat, a reorganiser manuellement si besoin).
#
# Usage : ./scripts/sync-from-claude.sh
# Env   : CLAUDE_SKILLS_PATH  (defaut : /mnt/skills/user)
#         CLAUDE_ORG_PATH     (defaut : /mnt/skills/organization)

set -euo pipefail
shopt -s nullglob

SKILLS_SOURCE="${CLAUDE_SKILLS_PATH:-/mnt/skills/user}"
ORG_SOURCE="${CLAUDE_ORG_PATH:-/mnt/skills/organization}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_ROOT="$REPO_ROOT/skills"

if [ ! -d "$SKILLS_SOURCE" ]; then
  echo "Source introuvable : $SKILLS_SOURCE"
  echo "Definir CLAUDE_SKILLS_PATH vers le dossier de skills Claude."
  exit 1
fi

# Construire la liste des skills organisation a exclure
ORG_SKILLS=()
if [ -d "$ORG_SOURCE" ]; then
  while IFS= read -r -d '' d; do
    ORG_SKILLS+=("$(basename "$d")")
  done < <(find "$ORG_SOURCE" -maxdepth 1 -mindepth 1 -type d -print0)
fi

echo "Source       : $SKILLS_SOURCE"
echo "Exclus (org) : ${ORG_SKILLS[*]:-<aucun>}"
echo "Destination  : $SKILLS_ROOT"
echo ""

SYNCED=0
for skill_dir in "$SKILLS_SOURCE"/*/; do
  skill_name=$(basename "$skill_dir")

  # Ignorer les skills organisation
  if [ ${#ORG_SKILLS[@]} -gt 0 ] && printf '%s\n' "${ORG_SKILLS[@]}" | grep -qx "$skill_name"; then
    echo "Ignore (organisation) : $skill_name"
    continue
  fi

  # Chercher si ce skill existe deja dans skills/ (quel que soit le sous-dossier thematique)
  existing=$(find "$SKILLS_ROOT" -maxdepth 3 -type d -name "$skill_name" 2>/dev/null | head -1)
  if [ -n "$existing" ]; then
    dest="$existing"
  else
    dest="$SKILLS_ROOT/$skill_name"
    echo "(nouveau) $skill_name → skills/$skill_name"
  fi

  # Copie propre : supprime la destination puis recopie (equivalent rsync --delete)
  rm -rf "$dest"
  cp -rp "$skill_dir" "$dest"
  # Supprimer les .DS_Store eventuels
  find "$dest" -name '.DS_Store' -delete 2>/dev/null || true
  echo "OK $skill_name"
  SYNCED=$((SYNCED + 1))
done

echo ""
if [ "$SYNCED" -eq 0 ]; then
  echo "Aucun skill synchronise. Verifier CLAUDE_SKILLS_PATH."
  exit 1
fi

echo "Sync termine ($SYNCED skills). Pense a commit & push :"
echo "   git add -A && git commit -m 'chore: sync skills $(date +%Y-%m-%d)' && git push"
