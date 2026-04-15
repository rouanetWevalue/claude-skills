#!/bin/bash
# Hook PostToolUse : propose une syncro apres modification d'un skill

INPUT=$(cat)

# Extraire le file_path depuis le JSON stdin
FILE=$(node -e "
try {
  var j = JSON.parse(require('fs').readFileSync(0,'utf8'));
  process.stdout.write((j.tool_input && j.tool_input.file_path) || '');
} catch(e) { process.stdout.write(''); }
" <<< "$INPUT")

# Verifier si le fichier appartient a un skill (SKILL.md ou references/*.md)
if echo "$FILE" | grep -qE '(SKILL\.md$|[/\\]references[/\\][^/\\]+\.md$)'; then
  MSG="Skill modifie - Pensez a synchroniser avec votre profil local :\n  ./scripts/sync-from-claude.sh"
  node -e "process.stdout.write(JSON.stringify({systemMessage: process.argv[1]}) + '\n')" -- "$MSG"
fi

exit 0
