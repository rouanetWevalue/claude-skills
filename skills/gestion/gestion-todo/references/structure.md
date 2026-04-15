# Structure — Hiérarchie et découpage des TODOs

## Modèle de hiérarchie

```
TODO.md                          ← fichier principal
  ## [SECTION-A] Titre           ← section thématique (H2)
      ### P0 — Bloquant
      ### P1 — Important
      ### P2 — Sprint suivant
      ### P3 — Backlog
  [ref] todo/infra.md            ← référence vers sous-fichier
  [ref] todo/agents.md
```

Les sous-fichiers suivent la même structure (sections → priorités).
2 niveaux recommandés, pas de limite de profondeur.

## Détection "fichier trop grand"

Seuil : `split_threshold` (défaut : 200 lignes).

| Config | Comportement |
|---|---|
| `disable_split_proposal: true` | Ne rien proposer — silence total |
| `auto_split: true` | Découpage automatique sans confirmation |
| défaut | Proposer le découpage avec plan de regroupement |

## Procédure de découpage (si proposé ou auto)

1. Analyser les sections existantes
2. Suggérer des regroupements thématiques (par domaine, feature, équipe)
3. Présenter le plan avant d'écrire :
   ```
   Plan de découpage proposé :
   todo/infra.md     ← [BACKUP], [NGINX-UPGRADE]
   todo/agents.md    ← [SINCRO-ENV], [SINCRO-CRON]
   TODO.md           ← index + références [ref]
   ```
4. Attendre validation (sauf `auto_split: true`)
5. Créer le dossier `todo_dir` (défaut : `todo/`), déplacer les sections,
   remplacer par des lignes `[ref] todo/fichier.md` dans `TODO.md`

## Réorganisation interne (sans découpage)

Pour réordonner les tâches au sein d'un fichier sans créer de sous-fichiers :
- Regrouper par section thématique
- Ordonner P0 → P3 au sein de chaque section
- Confirmer avant toute réécriture
