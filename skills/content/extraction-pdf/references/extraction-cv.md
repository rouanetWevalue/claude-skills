# Extraction PDF — CV et profil professionnel

Objectif : lire un PDF contenant un CV ou profil et produire un objet YAML conforme au schéma normalisation-profil.

Schéma de référence : `skills/cv/normalisation-profil/references/schema.md`

---

## Protocole d'extraction

1. **Lire le PDF en intégralité** — les CVs peuvent être multi-pages, multi-colonnes ou structurés en blocs non linéaires
2. **Identifier les sections** : identité, résumé/accroche, expériences, formations, compétences, langues, certifications, projets
3. **Reconstruire l'ordre chronologique** si les expériences ne sont pas présentées de façon lisible
4. **Inférer les champs non explicites** selon les règles du schéma (ex : type_contrat depuis le titre, niveau de compétence depuis le contexte)
5. **Produire le YAML complet** avec `null` pour tout champ absent — ne jamais omettre un champ du schéma

---

## Spécificités PDF à gérer

### Mise en page multi-colonnes
- Les PDFs de CV utilisent souvent 2 colonnes (compétences à gauche, expériences à droite)
- Reconstituer les sections dans leur intégralité même si le texte extrait est entremêlé
- Associer chaque compétence ou information latérale à la section correspondante

### En-têtes et pieds de page
- Ignorer les répétitions d'en-tête (nom, coordonnées) qui apparaissent sur chaque page
- Dédupliquer les coordonnées de contact si elles apparaissent plusieurs fois

### Tableaux et listes
- Les tableaux de compétences (grilles de niveau, barres de progression) : extraire nom + niveau inféré
- Les puces et listes numérotées sous une expérience → `realisations[]` du poste concerné

### Éléments graphiques
- Icônes, étoiles, barres de progression pour les niveaux de langue ou compétence : inférer le niveau (Débutant / Intermédiaire / Avancé / Expert) depuis la position visuelle décrite dans le texte extrait
- Si la représentation graphique n'est pas interprétable → `null` avec note `[?]`

---

## Mapping des sections courantes

| Section PDF | Champ schéma |
|---|---|
| Nom, prénom, titre | `identite.nom`, `identite.prenom`, `identite.titre` |
| Accroche, profil, à propos | `resume` |
| Expérience professionnelle | `experiences[]` |
| Formation, diplômes, études | `formations[]` |
| Compétences, outils, technologies | `competences[]` |
| Langues | `langues[]` |
| Certifications, habilitations | `certifications[]` |
| Projets personnels, open-source | `projets[]` |
| Publications, articles | `publications[]` |
| Distinctions, prix, récompenses | `distinctions[]` |
| Centres d'intérêt, loisirs | `centres_interet[]` |

---

## Format de sortie

Produire un bloc YAML conforme au schéma normalisation-profil avec :
- `meta.source: "pdf"`
- `meta.date_extraction:` date du jour (YYYY-MM-DD)
- Tous les champs présents, champs absents à `null`

---

## Cas particuliers

**CV très condensé (1 page)** : certaines sections peuvent être absentes — `null` accepté, ne pas inventer.

**CV en image (scan)** : signaler que l'extraction peut être partielle, marquer les zones illisibles `[?]`.

**Plusieurs profils dans un PDF** : extraire chaque profil séparément et les numéroter.
