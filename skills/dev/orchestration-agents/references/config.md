# Configuration — orchestration-agents

## Emplacement et priorité

| Fichier | Scope | Priorité |
|---|---|---|
| `~/.claude/orchestration-config.md` | Utilisateur (tous projets) | Base |
| `.claude/orchestration-config.md` | Projet (override utilisateur) | Haute |

Les deux peuvent coexister. Les valeurs du fichier projet écrasent celles du fichier utilisateur.

---

## Template de configuration

```markdown
# orchestration-config

## Comportement général

auto_confirm_decomposition: false
# true = valider automatiquement la décomposition sans attendre l'utilisateur

auto_confirm_review: false
# true = valider automatiquement après la revue, sans attendre l'utilisateur

skip_review: false
# true = ne pas lancer l'agent task-reviewer (bypass total de la revue auto)

## Limites

max_parallel_agents: 5
# Nombre maximum d'agents simultanés (défaut : 5, max absolu : 5)

## Modèles

model_decomposition: claude-sonnet-4-6
model_review: claude-sonnet-4-6
model_complex_task: claude-opus-4-6
model_simple_task: claude-haiku-4-5
```

---

## Bypass à la demande (sans fichier de config)

L'utilisateur peut bypasser à la volée au moment du lancement :

| Instruction utilisateur | Effet |
|---|---|
| "sans revue" / "skip review" | Équivalent `skip_review: true` pour cette session |
| "sans validation" / "auto-confirm" | Équivalent `auto_confirm_decomposition: true` et `auto_confirm_review: true` |
| "max N agents" | Override `max_parallel_agents` pour cette session |
| "utilise Opus" / "utilise Haiku" | Override le modèle pour les tâches de cette session |

---

## Valeurs par défaut (si aucun fichier de config)

| Paramètre | Valeur par défaut |
|---|---|
| `auto_confirm_decomposition` | `false` |
| `auto_confirm_review` | `false` |
| `skip_review` | `false` |
| `max_parallel_agents` | `5` |
| `model_decomposition` | `claude-sonnet-4-6` |
| `model_review` | `claude-sonnet-4-6` |
| `model_complex_task` | `claude-opus-4-6` |
| `model_simple_task` | `claude-haiku-4-5` |
