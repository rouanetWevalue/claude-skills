# Archive — Déplacer les sections complètes vers DONE.md

## Déclencheur

| Config | Comportement |
|---|---|
| `auto_archive: true` (défaut) | Archiver automatiquement quand toutes les tâches sont `[x]` |
| `auto_archive: false` | Signaler la section archivable, attendre demande explicite |

## Procédure

1. **Renommer le titre** : ajouter ` — finalisé YYYY-MM-DD` à la fin du titre de section
2. **Déplacer** : couper le bloc entier (titre + toutes les tâches) depuis `TODO.md`
3. **Coller dans `DONE.md`** : ajouter en début de fichier (plus récent en premier)
4. **Nettoyer** : supprimer la section de `TODO.md`

## Cas sous-fichiers

Si la section archivée provient d'un sous-fichier `[ref]` :
1. Supprimer la référence `[ref] chemin/fichier.md` dans `TODO.md`
2. Supprimer le bloc de la section dans le sous-fichier
3. Si le sous-fichier est vide après suppression → supprimer le fichier

## Confirmation

Avant d'écrire, afficher : "Section [TAG] complète — archivage dans DONE.md. Confirmer ?"
Sauf si `auto_confirm: true`.

## Format d'entrée dans DONE.md

```markdown
## [TAG] — Titre de la section — finalisé YYYY-MM-DD

- [x] Tâche 1 (YYYY-MM-DD)
- [x] Tâche 2 (YYYY-MM-DD)
```
