# Format des fichiers references/

## Rôle d'un fichier reference

Un fichier `references/` = **un seul concept**, chargé uniquement quand il est pertinent.
Il n'est pas lu en dehors du contexte qui l'a chargé. Il peut donc être dense et spécialisé.

---

## Contrainte absolue : ≤ 150 lignes (enforced by CI)

Si un fichier dépasse 150 lignes :
1. Identifier les deux sous-thèmes principaux
2. Scinder en deux fichiers distincts
3. Mettre à jour le tableau de routing dans SKILL.md

Exemple : `lang-yaml.md` (166 lignes) → `lang-yaml.md` (K8s/Helm) + `lang-yaml-cicd.md` (CI/CD)

---

## Structure recommandée

```markdown
# Titre du concept

## Principe fondamental (2-4 lignes max)
[Une phrase qui résume la règle centrale du fichier]

---

## Règles / Protocole
[Liste ou tableau — structure mécanique, facile à parcourir]

---

## Exemples
[Bon vs mauvais, avant/après — toujours par paires contrastées]

---

## Edge cases
[Cas limites explicitement nommés — les "et si..."]
```

---

## Quand créer un nouveau fichier vs enrichir l'existant

| Situation | Action |
|---|---|
| Le contenu appartient au même concept | Enrichir le fichier existant |
| Le fichier dépasse 120 lignes après ajout | Scinder — anticiper avant d'atteindre 150 |
| Le contenu couvre un sous-domaine distinct avec un déclencheur différent | Nouveau fichier + nouvelle ligne dans SKILL.md |
| Le contenu est un exemple de plus pour un cas existant | Remplacer l'exemple existant si moins bon, sinon ignorer |

---

## Règles de rédaction

**Concision** : chaque ligne doit valoir son coût de contexte. Supprimer les phrases
d'introduction génériques ("Dans cette section, nous allons...").

**Exemples contrastés** : toujours montrer le mauvais EN PREMIER, puis le bon.
Pourquoi : le cerveau (et Claude) retient mieux la correction que la règle abstraite.

**Termes cohérents** : utiliser les mêmes termes que SKILL.md et les autres references/.
Une incohérence de vocabulaire entre fichiers force Claude à réconcilier, ce qui
consomme des tokens et introduit des erreurs.

**Pas de doublons inter-fichiers** : si une règle est déjà dans `design.md`,
ne pas la répéter dans `checklist.md`. Référencer par nom si nécessaire.

---

## Anti-patterns

| Anti-pattern | Problème |
|---|---|
| Copier-coller de documentation officielle | Dense, non adapté au contexte, dépasse 150 lignes |
| Exemples trop abstraits (`foo`, `bar`) | Claude généralise mal — utiliser des exemples du domaine réel |
| Règles sans exemples | Ambiguïté sur l'interprétation |
| Un fichier "fourre-tout" | Chargé inutilement dans des contextes non pertinents |
