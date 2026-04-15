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

## Rétrospective DONE.md

Déclencheur : demande explicite (`"analyse DONE.md"`, `"rétrospective"`) ou lors d'un triage global.

Procédure :
1. Lire `DONE.md` et regrouper les tâches archivées par période (mois) et par tag
2. Calculer pour chaque catégorie :
   - Nombre de tâches complétées
   - Proportion P0/P1 (réactivité) vs P2/P3 (avancement planifié)
3. Identifier les patterns récurrents :
   - Tags avec beaucoup de P0 → domaine fragile ou sous-investi
   - Sections jamais complètes → dépendances bloquantes non résolues
   - Tâches rouvertes plusieurs fois → instabilité de vision
4. Présenter un résumé en 3–5 points dans ce format :

```
## Rétrospective — [période]

**Activité** : N tâches complétées — répartition : [TAG-A] N, [TAG-B] N
**Points forts** : [domaines avec vélocité ou stabilité]
**Points d'attention** : [domaines avec P0 récurrents ou blocages]
**Recommandations** : [ajustements de priorité ou de découpage]
```

## Format d'entrée dans DONE.md

```markdown
## [TAG] — Titre de la section — finalisé YYYY-MM-DD

- [x] Tâche 1 (YYYY-MM-DD)
- [x] Tâche 2 (YYYY-MM-DD)
```
