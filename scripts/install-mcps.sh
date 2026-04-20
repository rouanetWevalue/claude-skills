#!/usr/bin/env bash
# Installe et enregistre les MCPs définis dans mcps/*.json
# via la CLI Claude Code (scope utilisateur global)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
MCPS_DIR="$REPO_DIR/mcps"

if ! command -v claude &>/dev/null; then
  echo "❌ CLI claude introuvable — installer Claude Code d'abord"
  exit 1
fi

if ! command -v jq &>/dev/null; then
  echo "❌ jq requis mais non installé (winget install jqlang.jq)"
  exit 1
fi

for mcp_file in "$MCPS_DIR"/*.json; do
  name=$(jq -r '.name' "$mcp_file")
  cmd=$(jq -r '.server.command' "$mcp_file")
  args=$(jq -r '.server.args[]' "$mcp_file")

  echo "→ Enregistrement MCP : $name"
  # Construire la commande claude mcp add avec les args
  full_args=()
  while IFS= read -r arg; do
    full_args+=("$arg")
  done <<< "$args"

  claude mcp add "$name" -s user -- "$cmd" "${full_args[@]}" 2>&1 \
    && echo "  ✅ $name enregistré (scope utilisateur)" \
    || echo "  ⚠️  $name déjà enregistré ou erreur (voir ci-dessus)"
done

echo ""
echo "MCPs installés. Redémarre Claude Code pour les activer."
