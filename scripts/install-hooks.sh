#!/usr/bin/env bash
# install-hooks.sh — Installe les hooks git locaux du projet.
# A lancer une fois apres avoir clone le repo.
#
# Usage : ./scripts/install-hooks.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOOKS_SRC="$REPO_ROOT/scripts/git-hooks"
HOOKS_DEST="$REPO_ROOT/.git/hooks"

echo "Installation des hooks git..."
echo ""

for hook_file in "$HOOKS_SRC"/*; do
  hook_name=$(basename "$hook_file")
  cp "$hook_file" "$HOOKS_DEST/$hook_name"
  chmod +x "$HOOKS_DEST/$hook_name"
  echo "OK $hook_name"
done

echo ""
echo "Hooks installes dans $HOOKS_DEST"
echo "Pour verifier : ls -la $HOOKS_DEST"
