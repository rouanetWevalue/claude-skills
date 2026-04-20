# Guide de rédaction — Sections LinkedIn

## 1. Headline (220 caractères max)

### Formules gagnantes

| Axe | Structure | Exemple |
|---|---|---|
| Compétences | `[Rôle] | [Spécialité 1] & [Spécialité 2] | [Secteur]` | `Directrice RH | Transformation culturelle & GPEC | Industrie` |
| Valeur | `[Verbe d'action] + [bénéfice] + [pour qui]` | `J'aide les PME à structurer leur recrutement sans cabinet externe` |
| Identité | `[Métier] — [preuve d'impact ou chiffre]` | `Ingénieur cloud — 10 ans à réduire les coûts infra de 30 %+` |

### Règles headline

- Inclure au moins 1 mot-clé métier exact (recherché par les recruteurs)
- Éviter : "Passionné par", "En recherche de", "Dynamique et motivé"
- Tester les 3 variantes — laisser le candidat choisir selon le positionnement voulu
- Pas de ponctuation inutile ni d'emojis sauf usage sectoriel établi

---

## 2. About / Résumé (2 600 caractères max)

### Structure AIDA recommandée

```
Accroche (1 phrase) — Capter l'attention : chiffre, question, déclaration forte
Intérêt (1-2 phrases) — Qui je suis, ce que je fais, pour qui
Désir (1-2 phrases) — Mon approche, mes résultats, ma valeur différenciante
Action (1 phrase) — Invitation au contact ou appel implicite
```

### Version courte (3 lignes ≈ 400-500 caractères)

- Accroche + valeur principale + CTA en 3 lignes maximum
- Optimisée pour la lecture mobile (texte affiché sans "Voir plus")

### Version longue (5 lignes ≈ 900-1 200 caractères)

- Structure AIDA complète
- Inclure 3-5 mots-clés sectoriels dans le corps du texte (signal ATS)
- Terminer par une invitation concrète : "N'hésitez pas à me contacter" ou coordonnées

### À éviter

- Copier-coller de la fiche de poste actuelle
- Lister les compétences sans contexte ("Expert Excel, PowerPoint...")
- Écrire à la troisième personne

---

## 3. Expériences — Format CAR avec métriques

### Structure CAR

```
Contexte  → Situation initiale ou enjeu (1 ligne max)
Action    → Ce que j'ai fait concrètement (verbe d'action fort)
Résultat  → Outcome mesurable (chiffre, %, délai, volume, économie)
```

### Exemples de formulations CAR

| Avant (vague) | Après (CAR + métrique) |
|---|---|
| "Responsable du projet ERP" | "Piloté la migration ERP (SAP S/4HANA) pour 8 filiales — livré 3 semaines avant planning, 0 incident P1 à l'ouverture" |
| "Amélioration des processus RH" | "Refondé le process d'onboarding (6 étapes → 3) — time-to-productivity réduit de 45 jours à 28 jours" |
| "Gestion d'équipe commerciale" | "Animé une équipe de 12 commerciaux — CA équipe +18 % en 18 mois malgré contexte marché -5 %" |

### Verbes d'action forts (à préférer)

Piloté, Conçu, Déployé, Structuré, Négocié, Optimisé, Réduit, Accéléré, Lancé, Transformé

### Si aucune métrique disponible

Utiliser le placeholder explicite : `[chiffre à compléter]` — ne jamais inventer de données.
Proposer au candidat les types de métriques pertinentes pour son secteur.

---

## 4. Compétences — Logique ATS

### Priorités d'ajout

1. Compétences indispensables du marché cible (identifiées dans rapport marché §2)
2. Compétences techniques manquantes mais maîtrisées (absentes du profil, présentes en expérience)
3. Certifications récentes ou standards sectoriels (ex. PMP, CISSP, AWS, PRINCE2)

### Priorités de suppression

1. Technologies "en déclin" selon rapport marché (plus recherchées par < 10 % des offres)
2. Compétences génériques non différenciantes ("Microsoft Office", "Gestion du temps")
3. Doublons sémantiques : garder le terme exact le plus recherché par les ATS

### Règles d'organisation

- Grouper par catégorie : Techniques | Management | Sectorielles | Langues
- Placer en premier les compétences les plus recherchées sur le marché cible
- LinkedIn affiche les 50 premières — prioriser en conséquence
- Valider les endorsements (favoriser les compétences déjà endorsées)

### Si rapport marché absent

Marquer `competences.statut: non_evalue` dans l'output.
Proposer uniquement les compétences identifiables depuis le profil normalisé
(expériences → `competences_utilisees` → absentes de `competences[]`).
