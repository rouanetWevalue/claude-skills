# Worktrees — Travail multi-branches en parallèle

## Quand utiliser un worktree

| Situation | Worktree utile ? |
|---|---|
| Feature A et feature B en cours simultanément (sans `git stash` répété) | Oui |
| Tester une branche distante sans abandonner son travail en cours | Oui |
| Comparer deux implémentations côte à côte | Oui |
| Revue de code locale d'une PR complexe | Oui |
| Changement rapide de contexte (quelques minutes) | Non — préférer `git stash` |

---

## Convention de nommage anti-collision

| Type | Répertoire | Branche associée | Qui gère |
|---|---|---|---|
| Humain | `.worktrees/<nom>/` | `feat/xxx`, `fix/xxx` (Gitflow) | Développeur |
| Agent | `.claude/worktrees/<nom>/` | `worktree-<nom>` | superpowers skill / Claude |

Règle absolue : **ne jamais créer ni supprimer** un worktree dans `.claude/worktrees/` manuellement.
Ce répertoire est réservé aux agents Claude — un `rm -rf` ou un `git worktree prune` mal ciblé
peut supprimer un worktree actif utilisé par un subagent en cours d'exécution.

---

## Gitignore hygiene

Ajouter au `.gitignore` **avant** de créer un worktree local (et commiter cet ajout) :

```
.worktrees/
.claude/worktrees/
```

❌ Créer un worktree avant d'ignorer `.worktrees/` → Git le tracke, diff pollué, conflits futurs

✅ Vérifier l'ignore, commiter, puis créer le worktree :
```bash
git check-ignore -q .worktrees || echo "AJOUTER .worktrees/ au .gitignore"
```

---

## Lifecycle — Créer / Travailler / Nettoyer

### Créer

```bash
# 1. Vérifier que .worktrees/ est bien ignoré (voir section ci-dessus)

# 2. Créer le worktree sur une nouvelle branche
git worktree add .worktrees/feat-payments -b feat/payments

# 3. (Optionnel) Créer sur une branche existante
git worktree add .worktrees/feat-payments feat/payments
```

### Lister les worktrees actifs (humains + agents)

```bash
git worktree list
```

### Nettoyer (UNIQUEMENT les worktrees humains)

```bash
# Vérifier l'absence de changements non commités
git -C .worktrees/feat-payments status

# Supprimer le worktree
git worktree remove .worktrees/feat-payments

# Supprimer la branche locale si le travail est terminé
git branch -d feat/payments
```

❌ `git worktree prune` sans vérification préalable → risque de supprimer des worktrees agents actifs

✅ Supprimer uniquement par chemin explicite : `git worktree remove .worktrees/<nom>`

---

## Précautions sur les lock files

Les fichiers `package-lock.json`, `yarn.lock`, `go.sum`, `poetry.lock` peuvent diverger entre
worktrees si des dépendances sont installées indépendamment dans chacun.

❌ Installer une librairie dans le worktree sans synchroniser avec `main` → conflit garanti au merge

✅ Avant de merger, vérifier la divergence :
```bash
git diff main -- package-lock.json
git diff main -- go.sum
```

Si conflit de lock file au merge → regénérer depuis la branche cible :
```bash
npm install       # Node
go mod tidy       # Go
poetry lock       # Python/Poetry
```

Règle : ne pas installer de nouvelles dépendances dans un worktree secondaire sans s'assurer
qu'elles seront alignées avec la branche principale au moment du merge.

---

## Intégration avec superpowers:using-git-worktrees

| Situation | Action recommandée |
|---|---|
| Tu veux travailler **manuellement** sur 2 branches en parallèle | Ce fichier — setup manuel |
| Tu veux qu'un agent Claude travaille en isolation | Invoquer `superpowers:using-git-worktrees` |
| Tu veux plusieurs agents en parallèle | `superpowers:dispatching-parallel-agents` |

Le skill `superpowers:using-git-worktrees` gère la création automatisée des worktrees dans
`.claude/worktrees/` — il n'est **pas** destiné à l'usage humain direct. Ne pas le confondre
avec ce protocole de worktrees manuels.
