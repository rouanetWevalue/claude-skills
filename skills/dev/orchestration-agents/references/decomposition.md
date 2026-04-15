# Décomposition d'un problème en tâches atomiques

## Définition d'une tâche atomique

Une tâche est atomique si :
- Un seul sous-agent peut l'accomplir **sans dépendre d'un résultat en cours** d'une autre tâche
- Son périmètre tient dans le contexte d'un agent (fichiers concernés identifiables à l'avance)
- Son résultat est vérifiable (critère de "done" définissable)

---

## Décomposition par type de tâche

### Investigation
Découper par **domaine d'investigation indépendant**, pas par fichier.

| Granularité recommandée | Exemple |
|---|---|
| Une hypothèse à valider par agent | "Vérifier si la lenteur vient du réseau ou de la DB" → 2 agents |
| Un composant / service par agent | "Analyser les logs auth" + "Analyser les logs API" |
| Un aspect transverse par agent | "Sécurité" + "Performance" + "Accessibilité" |

Livrable attendu de chaque agent : résumé des findings + conclusion + fichiers concernés.

### Implémentation de feature
Découper par **module ou couche technique indépendante**.

| Granularité recommandée | Exemple |
|---|---|
| Une couche par agent (si interfaces définies) | "Implémenter le service" + "Implémenter le contrôleur" |
| Un sous-composant par agent | "Feature flag" + "Logique métier" + "Tests" |
| ⚠️ Ne pas paralléliser si | Les agents écrivent dans les mêmes fichiers |

### Correction d'anomalie
Découper par **bug isolé avec root cause distincte**.

| Granularité recommandée | Exemple |
|---|---|
| Un bug par agent | 3 tickets Jira → 3 agents indépendants |
| ⚠️ Ne pas paralléliser si | Les bugs partagent une cause racine commune (risque de conflits de fix) |

### Audit de code
Découper par **dimension d'audit** ou par **module**.

| Granularité recommandée | Exemple |
|---|---|
| Par dimension | "Sécurité" + "Performance" + "Maintenabilité" (même codebase) |
| Par module (grosse base) | "Module auth" + "Module paiement" + "Module notif" |

---

## Format de sortie — tableau de décomposition

Produire ce tableau avant de passer au modèle de décision :

| # | Tâche | Type | Périmètre (fichiers/modules) | Dépend de | Modèle suggéré |
|---|---|---|---|---|---|
| T1 | ... | investigation | ... | — | Sonnet |
| T2 | ... | feature | ... | T1 | Sonnet |
| T3 | ... | bug | ... | — | Haiku |

---

## Anti-patterns

| Anti-pattern | Problème | Correction |
|---|---|---|
| "Implémenter toute la feature" en une tâche | Trop large, context overflow | Découper par couche ou sous-composant |
| Deux tâches qui modifient le même fichier | Conflit de merge garanti | Fusionner en une tâche séquentielle |
| Tâche sans critère de "done" | Impossible de vérifier la completion | Définir le livrable attendu avant dispatch |
| Trop petites tâches (< 5 min) | Overhead orchestration > gain parallélisme | Fusionner les micro-tâches connexes |
