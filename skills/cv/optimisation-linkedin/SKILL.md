---
name: optimisation-linkedin
description: >
  Orchestre la réécriture du profil LinkedIn après audit.
  Prend en entrée : rapport d'audit (output de audit-profil-linkedin, obligatoire),
  profil normalisé YAML (output de normalisation-profil, obligatoire),
  rapport marché (output de analyse-marche-emploi, optionnel).
  Produit des améliorations rédigées section par section : 3 variantes de headline,
  2 versions du résumé About, reformulation des 2-3 expériences prioritaires (format CAR),
  liste de compétences optimisée (ajouts/suppressions ATS), recommandations non rédigeables.
  UTILISER après audit-profil-linkedin pour passer de l'audit à l'action.
---

# Optimisation LinkedIn — Point d'entrée

## Étape 1 — Vérifier les inputs

**Inputs obligatoires :**

- **Rapport d'audit** issu de `audit-profil-linkedin` (bloc YAML `audit:` avec `priorites[]`).
  Si absent → invoquer `audit-profil-linkedin` d'abord.
- **Profil normalisé YAML** conforme au schéma `normalisation-profil/references/schema.md`.
  Si absent → invoquer `normalisation-profil` d'abord.

**Input optionnel :**

| Input | Effet si absent |
|---|---|
| Rapport marché (`analyse-marche-emploi`) | Section `competences` marquée `non_evalue` — ajouts/suppressions ATS non produits |

---

## Étape 2 — Choisir le modèle

Utiliser `claude-sonnet-4-6` pour l'ensemble du skill.

> Règle : la réécriture de sections LinkedIn exige du jugement rédactionnel (ton, différenciation,
> formulation impactante) — Haiku ne suffit pas. Opus n'est pas justifié : il s'agit d'un profil
> unique sans décision architecturale ni arbitrage multi-sources complexe.

---

## Étape 3 — Charger la référence

Lire `references/sections-linkedin.md` — guide de rédaction par section : formules headline,
structure About (AIDA), format CAR avec métriques, logique compétences ATS.

---

## Étape 4 — Identifier les sections prioritaires

Lire `audit.priorites[]` du rapport d'audit dans **l'ordre de priorité déclaré**.
Le rapport d'audit a déjà classé les dimensions — ne pas ré-auditer.

| Dimension audit | Section à réécrire |
|---|---|
| `headline_resume` | Headline + About |
| `qualite_descriptions` | Expériences (2-3 les plus impactantes) |
| `pertinence_competences` | Compétences (si rapport marché disponible) |
| `completude` | Recommandations non rédigeables uniquement |
| `signaux_linkedin` | Recommandations non rédigeables uniquement |
| `coherence_narrative` | Reformulation du titre/résumé pour cohérence |

Traiter les sections dans l'ordre des priorités — ne pas produire de sections absentes du top 3
sauf si le temps le permet ou si l'utilisateur le demande explicitement.

---

## Étape 5 — Orchestrer la rédaction via `redaction`

Pour chaque section rédigeable identifiée à l'étape 4, invoquer le skill `redaction` en lui
transmettant :
1. **La réalisation ou la donnée source** extraite du profil normalisé YAML
2. **Le gap constaté** (champ `observation` du rapport d'audit)
3. **Le guide de rédaction** applicable depuis `references/sections-linkedin.md`
4. **Le ton cible** : professionnel, factuel, orienté impact — jamais promotionnel

`redaction` produit le texte rédigé. Ce skill assemble les outputs en bloc YAML structuré.

---

## Étape 6 — Produire l'output structuré

Toujours retourner un bloc YAML avec cette structure :

```yaml
optimisation:
  headline:
    variante_competences: "Expert en transformation digitale | IA & Data | Secteur Banque"
    variante_valeur: "J'aide les DSI à piloter leur migration cloud sans rupture métier"
    variante_identite: "Architecte cloud — 12 ans à transformer des SI complexes en leviers business"
  about:
    courte: |
      3 lignes max. Accroche forte + valeur principale + appel à l'action implicite.
    longue: |
      5 lignes. Structure AIDA : situation actuelle, problème résolu, approche,
      résultats, invitation au contact.
  experiences_reformulees:
    - poste: "Titre du poste — Entreprise (YYYY-MM à YYYY-MM)"
      realisations_optimisees:
        - "Contexte → Action → Résultat : [métrique chiffrée]"
        - "Contexte → Action → Résultat : [métrique chiffrée]"
  competences:
    a_ajouter:
      - competence: "Kubernetes"
        raison: "Indispensable selon rapport marché — absent du profil"
    a_supprimer:
      - competence: "SVN"
        raison: "En déclin selon rapport marché — nuit à la lisibilité ATS"
    statut: "evalue"   # "non_evalue" si rapport marché absent
  recommandations_non_redigeables:
    - element: "Photo de profil"
      action: "Utiliser une photo professionnelle, fond neutre, visage cadré à 60 %"
    - element: "URL personnalisée"
      action: "Configurer linkedin.com/in/prenom-nom dans Paramètres > Modifier le profil public"
    - element: "Activité LinkedIn"
      action: "Publier ou commenter 1 post/semaine dans le domaine cible pour le signal algorithme"
```

---

## Règles universelles

- **Ne jamais inventer de métriques** absentes du profil normalisé — si aucune métrique disponible,
  proposer un placeholder explicite : `[chiffre à compléter par le candidat]`
- **Toujours rester fidèle au profil source** — l'optimisation reformule, elle n'embellit pas
- **Signaler les sections non produites** : si une section prioritaire manque d'input suffisant,
  l'indiquer explicitement dans l'output avec la raison
