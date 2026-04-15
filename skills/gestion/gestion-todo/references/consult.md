# Consult — Lecture et résumé des TODOs

## Session start

Si `session_start_summary: true` (défaut) :
1. Lire le fichier défini par `todo_file` (défaut : `TODO.md`)
2. Lire les sous-fichiers référencés via `[ref] chemin/fichier.md` s'ils existent
3. Afficher le résumé standardisé ci-dessous

## Consultation explicite

Même comportement que session start. Filtres disponibles :
- Par priorité : ex. "montre les P1" → afficher seulement P1
- Par section : ex. "montre [BACKUP]" → afficher seulement cette section
- Par statut : ex. "en cours" → afficher seulement `[~]`

## Format de sortie standardisé

```
## TODOs ouverts — YYYY-MM-DD

### Débloqués — à traiter (N)
  P0 [TAG] Description
  P1 [TAG] Description

### P0 — Bloquant (N)
  [TAG] Description

### P1 — Important (N)
  [TAG] Description
  ⛔ [TAG] Description
      ✅ [TAG-A]  ⏳ "Créer l'espace de déploiement"  ⛔ "Fournir les credentials AWS"

### P2 — Sprint suivant (N)
  [TAG] Description

### P3 — Backlog (N)
  [TAG] Description

### Sections archivables
  [TAG] — toutes les tâches [x]
```

Si aucune tâche ouverte : afficher `Aucun TODO ouvert.`

## Règle débloqué / bloqué

Une tâche est **débloquée** si tous ses `needs:` sont résolus :
- `[TAG]` interne → résolu quand ce tag est `[x]` dans le fichier
- `"..."` externe → résolu quand préfixé `[x]` dans la ligne `needs:`

Affichage des needs pour chaque tâche bloquée :
- Lister **tous** les needs (résolus et non résolus) sur une ligne indentée
- `✅` → résolu (`[x]`)
- `⏳` → en cours (`[~]`)
- `⛔` → non résolu (`[ ]`)

Règles d'affichage :
- Section **"Débloqués — à traiter"** en premier, triée P0 → P3
- Tâches bloquées dans leurs sections de priorité : préfixées `⛔`, needs listés en dessous
- Si aucune tâche débloquée : `Toutes les tâches ouvertes sont bloquées par des prérequis.`

## Sous-fichiers

Si `TODO.md` contient des références `[ref] chemin/fichier.md` :
- Lire chaque sous-fichier référencé
- Inclure ses tâches dans le résumé avec le fichier source entre parenthèses :
  `[TAG] Description (todo/infra.md)`
