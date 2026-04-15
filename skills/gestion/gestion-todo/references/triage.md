# Triage — Réévaluation des priorités

## Principe

Ne jamais réévaluer systématiquement. Déclencher uniquement sur événement.

## Déclencheurs reconnus

- Ajout d'une nouvelle application ou fonctionnalité majeure au projet
- Incident ou blocage en production
- Changement d'équipe significatif
- Demande explicite de l'utilisateur
- Événements custom listés dans `triage_triggers` (config)

## Procédure

1. Lister toutes les tâches `[ ]` et `[~]` avec leur priorité actuelle
2. Pour chaque tâche impactée par le déclencheur, proposer une nouvelle priorité avec
   justification explicite.
   Exemple : `[AUTHENTIK] P3 → P1 — 4+ apps en production, SSO devient critique`
3. Présenter le delta complet avant d'écrire :
   ```
   Réévaluation proposée :
   [TAG-A] P3 → P1 — raison
   [TAG-B] P2 → P0 — raison
   ```
4. Attendre confirmation avant d'appliquer les changements

## Matrice Eisenhower (urgence × importance)

Grille de correspondance avec les niveaux P0–P3 :

|                   | Urgent                        | Non urgent                       |
|---|---|---|
| **Important**     | **P0** — Traiter maintenant   | **P1** — Planifier               |
| **Non important** | **P2** — Déléguer ou grouper  | **P3** — Backlog / éliminer      |

Utilisation lors d'un triage :
1. Pour chaque tâche réévaluée, poser les deux questions : "Important ?" et "Urgent ?"
2. Mapper le quadrant vers P0–P3
3. Appliquer ensuite la règle anti-inflation P0 ci-dessous

## Règle anti-inflation P0

Maximum 2-3 tâches P0 simultanément.
Si un ajout de P0 dépasse ce seuil → signaler et demander quelle tâche P0 existante doit descendre.

## Modification dans le fichier

Modifier uniquement le niveau de priorité dans la ligne concernée :
```
- [ ] Description — [TAG] P2  →  - [ ] Description — [TAG] P0
```
