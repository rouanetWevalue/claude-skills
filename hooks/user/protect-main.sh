#!/usr/bin/env bash
# Hook PreToolUse : bloque les push directs sur la branche par defaut.
# Detecte la branche par defaut dynamiquement (main, master, trunk, develop, etc.)
# Detecte :
#   - git push [remote] <defaut>  (branche par defaut mentionnee explicitement)
#   - git push [remote]           (sans branche, depuis la branche par defaut)
# Laisse passer :
#   - git push origin feat/xxx    (branche non-defaut explicite avec /)

INPUT=$(cat)

CMD=$(node -e "
try {
  var j = JSON.parse(require('fs').readFileSync(0,'utf8'));
  process.stdout.write((j.tool_input && j.tool_input.command) || '');
} catch(e) { process.stdout.write(''); }
" <<< "$INPUT")

# Ignorer si ce n'est pas un git push
echo "$CMD" | grep -qE '^git push(\s|$)' || exit 0

# Determiner la branche par defaut
# 1. Via refs/remotes/origin/HEAD (disponible apres clone ou git remote set-head)
DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||')

# 2. Fallback : premier remote tracking branch parmi les noms courants
if [ -z "$DEFAULT_BRANCH" ]; then
  for candidate in main master trunk develop; do
    if git show-ref --verify --quiet "refs/remotes/origin/$candidate" 2>/dev/null; then
      DEFAULT_BRANCH="$candidate"
      break
    fi
  done
fi

# Impossible de determiner -> laisser passer (ne pas bloquer par erreur)
[ -z "$DEFAULT_BRANCH" ] && exit 0

REASON=""

# Cas 1 : une branche explicite avec / est presente (ex: feat/xxx) -> laisser passer
# (traite en premier pour eviter les faux positifs sur les noms contenant DEFAULT_BRANCH)
if echo "$CMD" | grep -qE '\b[a-zA-Z0-9_-]+/[a-zA-Z0-9_/-]+\b'; then
  exit 0

# Cas 2 : la branche par defaut mentionnee explicitement comme cible
elif echo "$CMD" | grep -qE "\b${DEFAULT_BRANCH}\b"; then
  REASON="Push direct sur ${DEFAULT_BRANCH} interdit. Creer une branche feature/* et ouvrir une PR."

# Cas 3 : pas de branche specifiee, verifier si on est sur la branche par defaut
else
  CURRENT=$(git branch --show-current 2>/dev/null || true)
  if [ "$CURRENT" = "$DEFAULT_BRANCH" ]; then
    REASON="Push direct sur ${DEFAULT_BRANCH} interdit (branche courante : ${DEFAULT_BRANCH}). Creer une branche feature/* et ouvrir une PR."
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
