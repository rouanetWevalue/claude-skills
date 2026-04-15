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

### P0 — Bloquant (N)
  [TAG] Description de la tâche

### P1 — Important (N)
  [TAG] Description de la tâche

### P2 — Sprint suivant (N)
  [TAG] Description de la tâche

### P3 — Backlog (N)
  [TAG] Description de la tâche

### Sections archivables
  [TAG] — toutes les tâches [x]
```

Si aucune tâche ouverte : afficher `Aucun TODO ouvert.`

## Sous-fichiers

Si `TODO.md` contient des références `[ref] chemin/fichier.md` :
- Lire chaque sous-fichier référencé
- Inclure ses tâches dans le résumé avec le fichier source entre parenthèses :
  `[TAG] Description (todo/infra.md)`
