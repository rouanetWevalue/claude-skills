# Extraction DOCX/PPT — CV et profil professionnel

Objectif : lire un fichier DOCX ou PPT contenant un CV/profil et produire un objet YAML conforme au schéma normalisation-profil.

Schéma de référence : `skills/cv/normalisation-profil/references/schema.md`

---

## Protocole d'extraction

1. **Lire le document en intégralité** — DOCX multi-sections, PPT multi-slides
2. **Exploiter la hiérarchie des styles Word** pour identifier les sections (Titre 1 → section principale, Titre 2 → sous-section)
3. **Identifier les sections** : identité, résumé/accroche, expériences, formations, compétences, langues, certifications, projets
4. **Inférer les champs non explicites** selon les règles du schéma (ex : type_contrat depuis le titre, niveau depuis le contexte)
5. **Produire le YAML complet** avec `null` pour tout champ absent — ne jamais omettre un champ du schéma

---

## Spécificités DOCX à gérer

### Styles et hiérarchie
- **Heading 1 / Titre 1** → sections principales (Expériences, Formations, Compétences…)
- **Heading 2 / Titre 2** → sous-sections ou postes individuels
- **Normal / Corps de texte** → descriptions, réalisations, détails
- Ne pas ignorer le texte en **gras** ou *italique* : souvent utilisé pour les titres de poste, entreprises, dates

### Tableaux Word
- Les CVs DOCX utilisent fréquemment des tableaux pour la mise en page (2 colonnes : info à gauche, contenu à droite)
- Reconstruire les sections depuis le tableau en associant chaque cellule à sa signification contextuelle
- Les tableaux de compétences → extraire nom + niveau inféré depuis les étoiles, barres ou labels

### En-têtes et pieds de page
- Les coordonnées (email, téléphone, LinkedIn) apparaissent souvent en en-tête ou pied de page Word
- Les inclure dans `identite` — ne pas les ignorer même s'ils ne sont pas dans le corps principal

### Zones de texte et zones flottantes
- Les CVs DOCX complexes utilisent des zones de texte flottantes pour la mise en page
- Traiter leur contenu comme des sections normales selon leur position et contexte

---

## Spécificités PPT à gérer

### Slides de présentation de profil
- Slide titre → `identite` (nom, titre, coordonnées)
- Slides par expérience → un item `experiences[]` par slide
- Slide compétences → `competences[]`
- Slide formation → `formations[]`

### Zones de texte sur slide
- Chaque zone de texte est un bloc potentiel : lire toutes les zones même si elles semblent décoratives
- Les titres de slides → indicateurs de section (`H1` logique)

---

## Mapping des sections courantes

| Section DOCX/PPT | Champ schéma |
|---|---|
| Nom, prénom, titre (en-tête ou slide titre) | `identite.nom`, `identite.prenom`, `identite.titre` |
| Accroche, profil, à propos, summary | `resume` |
| Expérience professionnelle | `experiences[]` |
| Formation, diplômes, études, parcours académique | `formations[]` |
| Compétences, outils, technologies, stack | `competences[]` |
| Langues | `langues[]` |
| Certifications, habilitations | `certifications[]` |
| Projets personnels, open-source, réalisations | `projets[]` |
| Publications, articles | `publications[]` |
| Distinctions, prix, récompenses | `distinctions[]` |
| Centres d'intérêt, loisirs, hobbies | `centres_interet[]` |

---

## Format de sortie

Produire un bloc YAML conforme au schéma normalisation-profil avec :
- `meta.source: "docx"` (ou `"pptx"` selon le format)
- `meta.date_extraction:` date du jour (YYYY-MM-DD)
- Tous les champs présents, champs absents à `null`

---

## Cas particuliers

**DOCX protégé ou corrompu** : signaler l'impossibilité d'extraire certaines sections.

**PPT à thème graphique fort** : le texte peut être partiellement dans des formes graphiques — signaler si des zones ne sont pas accessibles en texte.

**Plusieurs profils dans un document** : extraire chaque profil séparément et les numéroter.
