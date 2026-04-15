#!/usr/bin/env bash
# Hook PreToolUse : bloque les push directs sur main.
# Detecte :
#   - git push [remote] main  (branche main mentionnee explicitement)
#   - git push [remote]       (sans branche, depuis la branche main)
# Laisse passer :
#   - git push origin feat/xxx (branche non-main explicite)

INPUT=$(cat)

CMD=$(node -e "
try {
  var j = JSON.parse(require('fs').readFileSync(0,'utf8'));
  process.stdout.write((j.tool_input && j.tool_input.command) || '');
} catch(e) { process.stdout.write(''); }
" <<< "$INPUT")

# Ignorer si ce n'est pas un git push
echo "$CMD" | grep -qE '^git push(\s|$)' || exit 0

REASON=""

# Cas 1 : une branche non-main explicite est presente (contient un /) -> laisser passer
# (traite en premier pour eviter les faux positifs sur les noms de branche contenant 'main')
if echo "$CMD" | grep -qE '\b[a-zA-Z0-9_-]+/[a-zA-Z0-9_/-]+\b'; then
  exit 0

# Cas 2 : 'main' mentionne explicitement comme branche cible
elif echo "$CMD" | grep -qE '\bmain\b'; then
  REASON="Push direct sur main interdit. Creer une branche feature/* et ouvrir une PR."

# Cas 3 : pas de branche specifiee, verifier si on est sur main
else
  CURRENT=$(git branch --show-current 2>/dev/null || true)
  if [ "$CURRENT" = "main" ]; then
    REASON="Push direct sur main interdit (branche courante : main). Creer une branche feature/* et ouvrir une PR."
  fi
fi

if [ -n "$REASON" ]; then
  node -e "process.stdout.write(JSON.stringify({
    hookSpecificOutput: {
      hookEventName: 'PreToolUse',
      permissionDecision: 'deny',
      permissionDecisionReason: process.argv[1]
    }
  }))" -- "$REASON"
fi

exit 0
