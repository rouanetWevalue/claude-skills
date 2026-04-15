# Dispatch des agents et collecte des résultats

## Pattern de dispatch parallèle

Envoyer **plusieurs appels Agent dans un seul message** — c'est ce qui les rend vraiment parallèles.

```
# ✅ Parallèle : un seul message, plusieurs Agent()
Agent(T1, description="Investiguer hypothèse réseau")
Agent(T2, description="Investiguer hypothèse DB")
Agent(T3, description="Investiguer hypothèse cache")

# ❌ Séquentiel involontaire : messages séparés
Agent(T1) → attendre → Agent(T2) → attendre → Agent(T3)
```

Pour les tâches qui modifient des fichiers, utiliser `isolation: "worktree"` pour éviter
les conflits entre agents parallèles.

---

## Contenu du prompt agent (ce qu'il faut transmettre)

Chaque agent reçoit dans son prompt :
- **Contexte** : pourquoi cette tâche existe, son rôle dans le plan global
- **Périmètre exact** : fichiers concernés, module, interface attendue
- **Critère de "done"** : comment savoir que la tâche est terminée
- **Contraintes** : fichiers à ne pas toucher, conventions à respecter
- **Livrable attendu** : format de sortie (résumé, diff, rapport, etc.)

Ne pas faire lire le plan complet par l'agent — lui transmettre uniquement sa tâche.

---

## Vérification avant dispatch

Avant de lancer les agents :

1. **Contrôle des conflits** : vérifier que deux agents du même batch n'ont pas de fichier en commun
   ```
   T1 : src/auth/service.ts ✓
   T2 : src/payment/service.ts ✓  → pas de conflit, parallèle OK
   T3 : src/auth/service.ts ✗     → conflit avec T1, rendre séquentiel
   ```

2. **Budget contexte** : estimer si la collecte des résultats rentrera dans le contexte restant
   - Règle pratique : prévoir ~2000 tokens par agent pour le résumé
   - Si N > 5 agents ou tâches très larges → demander des résumés courts (< 200 mots)

---

## Collecte séquentielle des résultats

Les résultats arrivent dans l'ordre de completion (pas dans l'ordre de dispatch).
Les traiter séquentiellement après que **tous** les agents du batch sont terminés.

Pour chaque résultat :
- Vérifier le statut : `DONE` / `DONE_WITH_CONCERNS` / `BLOCKED`
- Si `BLOCKED` : ne pas relancer le même agent sans changement — escalader à l'utilisateur ou passer à un modèle plus puissant
- Si `DONE_WITH_CONCERNS` : noter pour la revue automatique (ne pas ignorer)

---

## Intégration après collecte

Après collecte de tous les résultats d'un batch :

1. **Vérifier l'absence de conflits** entre ce que les agents ont produit (imports, types partagés)
2. **Lancer la revue automatique** via l'agent `task-reviewer` (sauf bypass config ou demande explicite)
3. **Présenter le résumé consolidé** à l'utilisateur avec :
   - Ce qui a été fait par agent
   - Concerns identifiés
   - Résultat de la revue automatique
4. **Attendre validation** avant de passer au batch suivant (sauf `auto_confirm: true`)

---

## Gestion des échecs partiels

| Situation | Action |
|---|---|
| 1 agent bloqué sur 3 | Continuer avec les 2 terminés, escalader le bloqué |
| Conflit de merge détecté | Rollback de l'agent conflictuel, refaire en séquentiel |
| Agent en timeout | Reporter la tâche, ne pas relancer sans diagnostic |
| Tous les agents du batch échouent | Arrêt et escalade utilisateur |
