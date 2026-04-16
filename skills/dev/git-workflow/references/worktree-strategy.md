# Worktrees — Stratégie de publication et conflits

## 1. Règle de scope — publication

| Situation | Règle |
|---|---|
| Modifications dans le même scope fonctionnel | Merger localement → une seule PR vers la branche racine |
| Modifications dans des scopes différents | PRs séparées, une par scope |
| Même scope mais volume trop important pour une review | Découper en sous-scopes → plusieurs PRs |

Le signal de taille est `scope-size: large` dans le `.worktree-config.md`.

❌ Ouvrir une PR unique qui mélange refactor auth + migration BDD + mise à jour CI → review impossible

✅ Trois PRs distinctes avec un ordre de merge explicite

---

## 2. Comportement sur scope large (`scope-size: large`) — `claude-opus-4-6`

> Évaluer si un scope est large et proposer un découpage sont des décisions architecturales.
> Une mauvaise coupe crée des dépendances impossibles entre branches — Opus requis.

Trois modes configurables via `scope-split` :

| Mode | Comportement |
|---|---|
| `ask` (défaut) | L'agent propose un découpage, attend la validation de l'utilisateur |
| `always` | L'agent découpe sans demander. Échec du découpage → travaille sur le scope large |
| `never` | L'agent travaille sur le scope large sans découper |

**Hiérarchie de configuration** (priorité décroissante) :
1. Prompt d'invocation : `scope-split: always`
2. Config projet : `.claude/worktree-defaults.md`
3. Config utilisateur : `~/.claude/worktree-defaults.md`
4. Défaut : `ask`

Format des fichiers de config :
```yaml
---
scope-split: ask   # ask | always | never
---
```

---

## 3. Schéma `.worktree-config.md`

Créé par l'orchestrateur à l'initialisation de chaque worktree, à sa racine.

```yaml
---
id: wt-auth-001                     # identifiant unique (références croisées)
branch: feat/auth-refactor          # branche de ce worktree
root-branch: main                   # branche d'origine du spawn initial
parent-branch: main                 # branche dans laquelle ce worktree sera mergé
parent-worktree-id: null            # id du worktree parent (null si issu de root-branch)
scope: "auth-refactor"              # description courte du périmètre
scope-size: medium                  # small | medium | large
scope-split: ask                    # ask | always | never (hérite de la config si absent)
publication: separate-pr            # separate-pr | merge-into-parent
status: in-progress                 # in-progress | ready | blocked | done
draft-pr: null                      # numéro de PR si draft créé
blocked-by: []                      # [{type: pr|worktree, ref: "#42"|"wt-xxx", reason: "..."}]
children: []                        # [{id, branch, status, publication}]
cleanup-after: "PR merged into main"
---

# Contexte agent

[Description du travail à faire, lue par l'agent au démarrage et après reprise.]
```

**Bidirectionnalité** : quand un agent crée un worktree enfant :
1. Il crée le `.worktree-config.md` de l'enfant avec `parent-worktree-id` pointant vers son `id`
2. Il met à jour son propre `.worktree-config.md` pour ajouter l'enfant dans `children`

Chaque agent lit le fichier dans son propre `cwd` — aucune confusion possible entre nœuds de l'arbre.

---

## 4. Règle PR cascadante

Si un enfant utilise `publication: separate-pr` → tous ses **ancêtres jusqu'à `root-branch`** doivent aussi être `separate-pr`.

Les ancêtres bloqués créent leur PR en **draft** :
- Titre : `[DRAFT] [Blocked: #XX, #YY] <titre>`
- Corps : liste des PRs bloquantes avec justification
- Mettre à jour `blocked-by` dans leur `.worktree-config.md`

❌ Merger un ancêtre avant que ses enfants bloquants soient mergés

✅ Créer la PR draft tôt pour la visibilité — la merger uniquement quand tous les `blocked-by` sont résolus

---

## 5. Résolution de conflits entre branches — `claude-opus-4-6`

> Optimisation multi-variables (criticité + cascade + impact croisé) — Opus requis.
> Pas de règle systématique — analyse par impact.

**Étapes :**

1. Lister les branches actives :
   ```bash
   git worktree list
   ```
2. Identifier les fichiers en commun entre chaque paire :
   ```bash
   git diff branch-A...branch-B --name-only
   ```
3. Construire le graphe de dépendances : quelles branches bloquent quelles autres
4. Trier par criticité (`scope-size` ou priorité P0-P3 si connue)
5. Merger en premier la branche qui modifie le plus les fichiers partagés — elle définit l'état de référence
6. Les branches suivantes se rebasent sur cet état :
   ```bash
   git rebase <branche-référence>
   ```

**Conflits anticipés** (deux worktrees connus pour toucher les mêmes fichiers) :

→ Sync régulier depuis la branche de référence pendant le développement :
```bash
git merge <branche-référence>   # ou : git rebase <branche-référence>
```

**Conflits non anticipés** (découverts au merge) :

→ Appliquer les étapes ci-dessus. Si ambiguïté sur la priorité → demander à l'utilisateur.
