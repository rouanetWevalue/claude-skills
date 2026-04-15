# Edit — Ajouter et mettre à jour des TODOs

## Format d'une tâche

```
- [ ] Description courte — [TAG] Pniveau
```

Exemple : `- [ ] Configurer le backup ChromaDB — [BACKUP] P2`

## Prérequis optionnels (needs:)

Deux types de prérequis, combinables sur la même ligne :

**Interne** — autre TODO du projet, identifié par son tag :
```
- [ ] Description — [TAG] Pniveau
  needs: [AUTRE-TAG]
```

**Externe** — action hors du projet (identifiants, décision, accès, arbitrage) :
```
- [ ] Description — [TAG] Pniveau
  needs: "Whitelister l'URL en prod"
```

Les deux types peuvent coexister :
```
- [ ] Description — [TAG] Pniveau
  needs: [TAG-A], "Fournir les credentials AWS", [TAG-B]
```

### État d'un prérequis

Chaque prérequis porte un statut explicite, identique à celui des tâches :

| Préfixe | Signification |
|---|---|
| `[ ]` | Non résolu / non démarré |
| `[~]` | En cours de résolution |
| `[x]` | Résolu |

- Les `needs:` restent visibles jusqu'à ce que la tâche elle-même soit `[x]`
- Pour les prérequis **internes**, le statut peut aussi être inféré du tag référencé dans le fichier — le préfixe explicite reste recommandé pour la lisibilité
- Pour les prérequis **externes**, le statut doit toujours être maintenu manuellement

Exemple d'évolution :
```
- [~] Description — [TAG] Pniveau (en cours — en attente de credentials)
  needs: [x] [TAG-A], [~] "Créer l'espace de déploiement", [ ] "Fournir les credentials AWS"
```
→ TAG-A résolu, déploiement en cours, credentials pas encore fournis.

### Règles de blocage

- **Débloquée** : tous les needs sont `[x]`
- **Bloquée** : au moins un need est `[ ]` ou `[~]`
- Ne jamais ajouter `needs:` à une tâche `[x]`
- Ajouter `needs:` à une tâche `[~]` est autorisé : prérequis identifié en cours d'exécution, nécessaire pour finaliser

## Ajouter un TODO

1. Si section, tag ou priorité manquants → demander avant d'écrire
2. Insérer à la bonne position dans la section (P0 avant P1, P1 avant P2, etc.)
3. Si sous-fichiers existent → demander dans quel fichier insérer
4. Confirmer avant écriture (sauf `auto_confirm: true`)

## Mettre à jour le statut

| Transition | Résultat |
|---|---|
| → `[x]` | `- [x] Description — [TAG] Pniveau (YYYY-MM-DD)` |
| → `[~]` | `- [~] Description — [TAG] Pniveau (en cours — note optionnelle)` |
| → `[ ]` | Retirer la date ou note, retour à l'état ouvert |

Après chaque passage à `[x]` :
- Vérifier si toutes les tâches de la section sont `[x]`
- Si oui → appliquer la logique de `references/archive.md`

## Convention inline dans le code

Si l'utilisateur modifie un fichier source lié à un TODO, rappeler :
```
// TODO[TAG]: description — voir TODO.md#TAG
```

## Interdits

- Ne jamais modifier plusieurs tâches sans confirmation intermédiaire
- Ne jamais supprimer une tâche — utiliser `[x]` puis archiver
