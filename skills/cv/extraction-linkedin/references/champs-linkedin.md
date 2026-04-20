# Mapping LinkedIn → schéma normalisation-profil

Schéma de référence : `skills/cv/normalisation-profil/references/schema.md`

Objectif : mapper chaque section d'un profil LinkedIn (texte brut copié ou extrait via Playwright) vers les champs du schéma normalisation-profil.

---

## Section Identité (en-tête du profil)

| Champ LinkedIn | Champ schéma | Notes |
|---|---|---|
| Prénom + Nom (H1 de la page) | `identite.prenom`, `identite.nom` | Séparer sur le premier espace |
| Headline (sous le nom) | `identite.titre` | Texte tel quel |
| Localisation | `identite.localisation` | Format "Ville, Pays" |
| URL du profil (linkedin.com/in/…) | `identite.linkedin_url` | URL canonique |
| Email (si visible dans Coordonnées) | `identite.email` | |
| Téléphone (si visible) | `identite.telephone` | |
| Site web / Portfolio (si visible) | `identite.site_web` ou `identite.portfolio_url` | |
| Lien GitHub (si visible) | `identite.github_url` | |

> Les coordonnées sont parfois masquées par LinkedIn — `null` si non accessibles.

---

## Section About / Infos (résumé)

| Champ LinkedIn | Champ schéma | Notes |
|---|---|---|
| Texte de la section "Infos" ou "About" | `resume` | Texte libre, 3–5 phrases idéalement |

---

## Section Expérience

Chaque poste → un item `experiences[]`.

| Champ LinkedIn | Champ schéma | Notes |
|---|---|---|
| Titre du poste | `poste` | |
| Nom de l'entreprise | `entreprise` | |
| Type de contrat (si mentionné) | `type_contrat` | Inférer depuis : "Freelance", "Stage", "Alternance", "Bénévole", sinon "CDI" par défaut |
| Dates (ex : "jan. 2022 – présent") | `date_debut`, `date_fin` | Convertir en YYYY-MM ; "présent" → `"présent"` |
| Localisation du poste | `localisation` | |
| Description du poste | `description` | |
| Puces sous le poste | `realisations[]` | Chaque puce → un item ; extraire `metrique` si chiffre présent |
| Compétences associées au poste | `competences_utilisees` | Listées sous "Compétences" dans l'expérience |

**Postes groupés** : LinkedIn peut grouper plusieurs postes sous une même entreprise. Créer un item `experiences[]` distinct par poste.

---

## Section Formation

Chaque formation → un item `formations[]`.

| Champ LinkedIn | Champ schéma | Notes |
|---|---|---|
| Établissement | `etablissement` | |
| Diplôme / Titre | `diplome` | Ex : "Master", "Licence", "MBA" |
| Domaine / Filière | `domaine` | |
| Dates | `date_debut`, `date_fin` | YYYY-MM |
| Mention / Grade (si présent) | `mention` | |
| Description (si présente) | `description` | |

---

## Section Compétences (Skills)

Chaque compétence → un item `competences[]`.

| Champ LinkedIn | Champ schéma | Notes |
|---|---|---|
| Nom de la compétence | `nom` | |
| Catégorie inférée | `categorie` | Inférer : Langages, Frameworks, Cloud, Outils, Méthodes, Soft skills |
| Niveau inféré | `niveau` | Inférer depuis : nombre d'années d'utilisation dans les expériences, certifications, endorsements |

> LinkedIn affiche les compétences par ordre d'endorsements — utiliser cela comme signal de niveau relatif.

---

## Section Certifications

Chaque certification → un item `certifications[]`.

| Champ LinkedIn | Champ schéma | Notes |
|---|---|---|
| Nom de la certification | `nom` | |
| Organisme émetteur | `organisme` | |
| Date d'obtention | `date` | YYYY-MM |
| Date d'expiration (si présente) | `expiration` | YYYY-MM ou `"aucune"` |
| URL de vérification (si présente) | `url` | |

---

## Sections supplémentaires

| Section LinkedIn | Champ schéma |
|---|---|
| Publications, Articles | `publications[]` |
| Projets | `projets[]` |
| Distinctions et récompenses | `distinctions[]` |
| Centres d'intérêt / Associations | `centres_interet[]` |

---

## Cas particuliers

**Profil en anglais** : conserver les valeurs dans la langue du profil ; indiquer `meta.langue_profil: "en"`.

**Sections masquées ou tronquées** : LinkedIn masque parfois le contenu ("Voir plus") — signaler avec `[?]` si une section semble incomplète.

**Recommandations** : ne font pas partie du schéma normalisation-profil — ignorer.

**Followers / connexions** : données de réseau, ignorer.
