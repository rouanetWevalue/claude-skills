#!/bin/bash
# Hook PostToolUse : propose une syncro apres modification d'un skill ou d'un agent

INPUT=$(cat)

# Extraire le file_path depuis le JSON stdin
FILE=$(node -e "
try {
  var j = JSON.parse(require('fs').readFileSync(0,'utf8'));
  process.stdout.write((j.tool_input && j.tool_input.file_path) || '');
} catch(e) { process.stdout.write(''); }
" <<< "$INPUT")

# Normaliser les backslashes Windows en forward slashes avant le test
FILE_NORM=$(echo "$FILE" | tr '\\' '/')

# Verifier si le fichier appartient a un skill ou a un agent
if echo "$FILE_NORM" | grep -qE '(skills/.*SKILL\.md$|skills/.*/references/[^/]+\.md$|agents/.*/AGENT\.md$)'; then
  MSG="Skill ou agent modifie - Pensez a synchroniser avec votre profil local :\n  ./scripts/sync-to-claude.sh"
  node -e "process.stdout.write(JSON.stringify({systemMessage: process.argv[1]}) + '\n')" -- "$MSG"
fi

exit 0
