# generation-cv-docx Multi-Templates Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Étendre le skill `generation-cv-docx` pour proposer 4 templates (classique, moderne, minimaliste, wevalue-stub), collecter les infos complémentaires une seule fois, et paralléliser la génération multi-templates via sous-agents.

**Architecture:** On conserve le skill existant en le restructurant : `python-docx-patterns.md` devient `shared-patterns.md` (utilitaires communs), chaque template obtient son propre fichier de référence `template-<nom>.md`, et `infos-complementaires.md` centralise les champs requis par template. `SKILL.md` orchestre la sélection (simple ou multiple), la collecte unifiée des infos, et le dispatch via `orchestration-agents` pour le cas multi-templates.

**Tech Stack:** Markdown (skill files), python-docx (patterns dans les références), git (commits fréquents), CI GitHub Actions (validation ≤150 lignes)

---

## Fichiers créés / modifiés

| Action | Fichier | Responsabilité |
|---|---|---|
| Renommer | `references/python-docx-patterns.md` → `references/shared-patterns.md` | Utilitaires python-docx communs à tous les templates |
| Créer | `references/infos-complementaires.md` | Mapping template → champs requis + règle photo |
| Créer | `references/template-classique.md` | Layout Classique Corporate (Georgia, navy, 1 col) |
| Créer | `references/template-moderne.md` | Layout Moderne Bicolonne (sidebar verte, photo opt.) |
| Créer | `references/template-minimaliste.md` | Layout Minimaliste ATS-Safe (Arial, noir, 1 col) |
| Créer | `references/template-wevalue.md` | Stub WeValue (message + instructions futures) |
| Modifier | `SKILL.md` | Routing multi-templates, collecte unifiée, dispatch sous-agents |

Tous les fichiers sous `references/` : contrainte CI ≤ 150 lignes.

---

## Task 1 — Renommer shared-patterns.md

**Files:**
- Rename: `skills/cv/generation-cv-docx/references/python-docx-patterns.md` → `skills/cv/generation-cv-docx/references/shared-patterns.md`

- [ ] **Étape 1 : Vérifier que le fichier source existe**

```bash
wc -l skills/cv/generation-cv-docx/references/python-docx-patterns.md
```
Résultat attendu : un nombre de lignes affiché (fichier présent)

- [ ] **Étape 2 : Renommer via git mv**

```bash
git mv skills/cv/generation-cv-docx/references/python-docx-patterns.md \
       skills/cv/generation-cv-docx/references/shared-patterns.md
```

- [ ] **Étape 3 : Ajouter un en-tête de contexte au fichier**

Lire `skills/cv/generation-cv-docx/references/shared-patterns.md` puis ajouter en tête de fichier (avant la ligne 1) :

```markdown
# Patterns python-docx partagés — tous templates CV DOCX

Utilitaires communs chargés par tous les templates.
Chaque fichier `template-<nom>.md` s'appuie sur ces helpers de base.

```

- [ ] **Étape 4 : Valider la contrainte CI**

```bash
wc -l skills/cv/generation-cv-docx/references/shared-patterns.md
```
Résultat attendu : nombre ≤ 150

- [ ] **Étape 5 : Commit**

```bash
git add skills/cv/generation-cv-docx/references/shared-patterns.md
git commit -m "refactor(cv-docx): rename python-docx-patterns → shared-patterns"
```

---

## Task 2 — Créer infos-complementaires.md

**Files:**
- Create: `skills/cv/generation-cv-docx/references/infos-complementaires.md`

- [ ] **Étape 1 : Vérifier que le fichier n'existe pas encore**

```bash
ls skills/cv/generation-cv-docx/references/infos-complementaires.md 2>/dev/null \
  && echo "EXISTE DÉJÀ" || echo "OK — à créer"
```
Résultat attendu : `OK — à créer`

- [ ] **Étape 2 : Créer le fichier avec son contenu complet**

Créer `skills/cv/generation-cv-docx/references/infos-complementaires.md` :

```markdown
# Infos complémentaires — par template CV DOCX

Ce fichier est chargé à l'Étape 2 du routing pour identifier les champs
à collecter selon le ou les templates sélectionnés.

**Règle universelle** : tout champ non fourni par l'utilisateur → valeur `None`
dans le dictionnaire Python. Le template doit omettre le bloc correspondant
(`if valeur:`) — ne jamais afficher un label sans valeur.

---

## classique

Champs à vérifier dans le profil YAML (demander si absent) :
- `linkedin_url` : URL profil LinkedIn (ex : https://linkedin.com/in/prenom-nom)
- `site_web` : portfolio ou site personnel (optionnel)

Photo : **non supportée** par ce template.

---

## moderne

Champs à vérifier dans le profil YAML (demander si absent) :
- `linkedin_url` : URL profil LinkedIn
- `site_web` : portfolio ou site personnel (optionnel)
- `github_url` : profil GitHub (optionnel)

Photo : **optionnelle**.
→ Si absente du profil YAML : demander "Souhaitez-vous inclure une photo ?
  Si oui, fournissez le chemin absolu du fichier image (.jpg ou .png)."
→ Si l'utilisateur ne souhaite pas de photo : `chemin_photo = None`
→ La photo est insérée en haut de la sidebar avec `width=Cm(3.5)`
  (nécessite `pip install Pillow` en plus de python-docx)

---

## minimaliste

Champs à vérifier dans le profil YAML (demander si absents) :
- `email` : adresse email de contact
- `telephone` : numéro de téléphone
- `localisation` : ville et/ou pays

Photo : **non supportée** (incompatible avec les parseurs ATS — les images
sont ignorées ou génèrent des erreurs de parsing).

---

## wevalue

→ Template en attente de la charte graphique WeValue.
  Infos complémentaires à définir lors de l'implémentation du template.
  Voir `template-wevalue.md` pour les instructions.
```

- [ ] **Étape 3 : Valider la contrainte CI**

```bash
wc -l skills/cv/generation-cv-docx/references/infos-complementaires.md
```
Résultat attendu : nombre ≤ 150

- [ ] **Étape 4 : Commit**

```bash
git add skills/cv/generation-cv-docx/references/infos-complementaires.md
git commit -m "feat(cv-docx): add infos-complementaires reference"
```

---

## Task 3 — Créer template-classique.md

**Files:**
- Create: `skills/cv/generation-cv-docx/references/template-classique.md`

- [ ] **Étape 1 : Créer le fichier**

Créer `skills/cv/generation-cv-docx/references/template-classique.md` :

````markdown
# Template Classique Corporate — CV DOCX

## Caractéristiques
- Mise en page : colonne unique · Police : Georgia (serif)
- Couleur principale : bleu ardoise `#2c3e50` · Photo : non supportée
- Cible : corporate, finance, conseil traditionnel

## Preamble

```python
from docx import Document
from docx.shared import Pt, Cm, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml.ns import qn
from docx.oxml import OxmlElement

BLEU = RGBColor(0x2C, 0x3E, 0x50)
doc = Document()
for s in doc.sections:
    s.top_margin = Cm(2); s.bottom_margin = Cm(2)
    s.left_margin = Cm(2.5); s.right_margin = Cm(2.5)
```

## En-tête

```python
def entete(doc, identite, linkedin_url=None, site_web=None):
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run(f"{identite['prenom']} {identite['nom']}")
    r.bold = True; r.font.size = Pt(18); r.font.name = 'Georgia'
    r.font.color.rgb = BLEU
    if identite.get('titre'):
        p2 = doc.add_paragraph()
        p2.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p2.add_run(identite['titre']).font.size = Pt(11)
    coords = [x for x in [
        identite.get('email'), identite.get('telephone'),
        identite.get('localisation'), linkedin_url, site_web
    ] if x]
    if coords:
        p3 = doc.add_paragraph(' | '.join(coords))
        p3.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p3.runs[0].font.size = Pt(9)
        pBdr = OxmlElement('w:pBdr')
        bottom = OxmlElement('w:bottom')
        bottom.set(qn('w:val'), 'single'); bottom.set(qn('w:sz'), '6')
        bottom.set(qn('w:color'), '2C3E50')
        pBdr.append(bottom)
        p3._p.get_or_add_pPr().append(pBdr)
```

## Titre de section

```python
def titre_section(doc, texte):
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(10)
    p.paragraph_format.space_after = Pt(4)
    r = p.add_run(texte.upper())
    r.bold = True; r.font.size = Pt(11); r.font.name = 'Georgia'
    r.font.color.rgb = BLEU
    pBdr = OxmlElement('w:pBdr')
    bottom = OxmlElement('w:bottom')
    bottom.set(qn('w:val'), 'single'); bottom.set(qn('w:sz'), '4')
    bottom.set(qn('w:color'), '2C3E50')
    pBdr.append(bottom)
    p._p.get_or_add_pPr().append(pBdr)
```

## Expériences (pattern appliqué à toutes les sections similaires)

```python
def experiences(doc, exps):
    if not exps: return
    titre_section(doc, 'Expériences professionnelles')
    for e in exps:
        p = doc.add_paragraph()
        p.paragraph_format.space_before = Pt(6)
        r = p.add_run(f"{e.get('poste','')} — {e.get('entreprise','')}")
        r.bold = True; r.font.size = Pt(11); r.font.name = 'Georgia'
        dates = f"{e.get('date_debut','')}–{e.get('date_fin','présent')}"
        if e.get('localisation'):
            dates += f" · {e['localisation']}"
        p.add_run(f"  |  {dates}").italic = True
        if e.get('description'):
            doc.add_paragraph(e['description']).paragraph_format.space_after = Pt(2)
        for real in e.get('realisations', []):
            p_b = doc.add_paragraph(style='List Bullet')
            p_b.paragraph_format.space_after = Pt(2)
            p_b.add_run(real.get('texte', ''))
```

## Appel final

```python
entete(doc, profil['identite'], linkedin_url=linkedin_url, site_web=site_web)
if profil.get('resume'):
    titre_section(doc, 'Résumé professionnel')
    doc.add_paragraph(profil['resume'])
experiences(doc, profil.get('experiences', []))
# formations, compétences, langues, certifications — même pattern que experiences()
doc.save('cv-classique.docx')
print('cv-classique.docx généré.')
```
````

- [ ] **Étape 2 : Valider la contrainte CI**

```bash
wc -l skills/cv/generation-cv-docx/references/template-classique.md
```
Résultat attendu : nombre ≤ 150

- [ ] **Étape 3 : Commit**

```bash
git add skills/cv/generation-cv-docx/references/template-classique.md
git commit -m "feat(cv-docx): add template-classique reference"
```

---

## Task 4 — Créer template-moderne.md

**Files:**
- Create: `skills/cv/generation-cv-docx/references/template-moderne.md`

- [ ] **Étape 1 : Créer le fichier**

Créer `skills/cv/generation-cv-docx/references/template-moderne.md` :

````markdown
# Template Moderne Bicolonne — CV DOCX

## Caractéristiques
- Sidebar gauche 38% (fond vert `#2d6a4f`, texte blanc) + colonne droite 62% (fond blanc)
- Police : Arial · Photo : optionnelle (haut de sidebar)
- Cible : tech, startup, créatif

## Preamble

```python
from docx import Document
from docx.shared import Pt, Cm, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml.ns import qn
from docx.oxml import OxmlElement

VERT  = RGBColor(0x2D, 0x6A, 0x4F)
BLANC = RGBColor(0xFF, 0xFF, 0xFF)
VERT_CLAIR = RGBColor(0xA8, 0xD8, 0xBF)

doc = Document()
for s in doc.sections:
    s.top_margin = Cm(1.5); s.bottom_margin = Cm(1.5)
    s.left_margin = Cm(1.5); s.right_margin = Cm(1.5)
```

## Helpers layout bicolonne

```python
def set_cell_bg(cell, hex_color):
    shd = OxmlElement('w:shd')
    shd.set(qn('w:val'), 'clear')
    shd.set(qn('w:color'), 'auto')
    shd.set(qn('w:fill'), hex_color)
    cell._tc.get_or_add_tcPr().append(shd)

def remove_borders(table):
    tblPr = table._tbl.tblPr
    tblBorders = OxmlElement('w:tblBorders')
    for b in ['top','left','bottom','right','insideH','insideV']:
        el = OxmlElement(f'w:{b}')
        el.set(qn('w:val'), 'none')
        tblBorders.append(el)
    tblPr.append(tblBorders)

table = doc.add_table(rows=1, cols=2)
remove_borders(table)
table.columns[0].width = Cm(6.5)
table.columns[1].width = Cm(10.5)
gauche = table.cell(0, 0)
droite = table.cell(0, 1)
set_cell_bg(gauche, '2d6a4f')
```

## Helpers sidebar (colonne gauche)

```python
def p_sidebar(cell, texte, bold=False, size=9):
    p = cell.add_paragraph()
    p.paragraph_format.space_after = Pt(2)
    r = p.add_run(texte)
    r.bold = bold; r.font.size = Pt(size); r.font.color.rgb = BLANC

def titre_sidebar(cell, texte):
    p = cell.add_paragraph()
    p.paragraph_format.space_before = Pt(8)
    r = p.add_run(texte.upper())
    r.bold = True; r.font.size = Pt(8); r.font.color.rgb = VERT_CLAIR

def ajouter_photo(cell, chemin):
    if not chemin: return
    p = cell.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_after = Pt(8)
    p.add_run().add_picture(chemin, width=Cm(3.5))

def entete_sidebar(gauche, identite, linkedin_url=None,
                   site_web=None, github_url=None, photo=None):
    ajouter_photo(gauche, photo)
    p_sidebar(gauche, f"{identite['prenom']} {identite['nom']}", bold=True, size=13)
    if identite.get('titre'): p_sidebar(gauche, identite['titre'], size=9)
    titre_sidebar(gauche, 'Contact')
    for v in [identite.get('email'), identite.get('telephone'),
              identite.get('localisation'), linkedin_url, site_web, github_url]:
        if v: p_sidebar(gauche, v, size=8)

def competences_sidebar(gauche, competences):
    if not competences: return
    titre_sidebar(gauche, 'Compétences')
    for c in competences:
        nom = c.get('nom') if isinstance(c, dict) else c
        if nom: p_sidebar(gauche, f'▸ {nom}', size=8)
```

## Helpers colonne droite

```python
def titre_droite(cell, texte):
    p = cell.add_paragraph()
    p.paragraph_format.space_before = Pt(10)
    r = p.add_run(texte.upper())
    r.bold = True; r.font.size = Pt(10); r.font.color.rgb = VERT
    pBdr = OxmlElement('w:pBdr')
    bottom = OxmlElement('w:bottom')
    bottom.set(qn('w:val'), 'single'); bottom.set(qn('w:sz'), '4')
    bottom.set(qn('w:color'), '2d6a4f')
    pBdr.append(bottom)
    p._p.get_or_add_pPr().append(pBdr)

def exp_droite(cell, e):
    p = cell.add_paragraph()
    p.paragraph_format.space_before = Pt(5)
    r = p.add_run(f"{e.get('poste','')} · {e.get('entreprise','')}")
    r.bold = True; r.font.size = Pt(10)
    dates = f"{e.get('date_debut','')}–{e.get('date_fin','présent')}"
    p2 = cell.add_paragraph(dates)
    p2.runs[0].font.size = Pt(8)
    for real in e.get('realisations', []):
        pb = cell.add_paragraph()
        pb.paragraph_format.left_indent = Pt(10)
        pb.add_run(f"▸ {real.get('texte','')}").font.size = Pt(9)
```

## Appel final

```python
entete_sidebar(gauche, profil['identite'], linkedin_url=linkedin_url,
    site_web=site_web, github_url=github_url, photo=chemin_photo)
if profil.get('competences'): competences_sidebar(gauche, profil['competences'])
if profil.get('resume'):
    titre_droite(droite, 'Profil'); droite.add_paragraph(profil['resume'])
if profil.get('experiences'):
    titre_droite(droite, 'Expériences')
    for e in profil['experiences']: exp_droite(droite, e)
# formations, langues — même pattern que exp_droite()
doc.save('cv-moderne.docx')
print('cv-moderne.docx généré.')
```
````

- [ ] **Étape 2 : Valider la contrainte CI**

```bash
wc -l skills/cv/generation-cv-docx/references/template-moderne.md
```
Résultat attendu : nombre ≤ 150

- [ ] **Étape 3 : Commit**

```bash
git add skills/cv/generation-cv-docx/references/template-moderne.md
git commit -m "feat(cv-docx): add template-moderne reference (bicolonne + photo)"
```

---

## Task 5 — Créer template-minimaliste.md

**Files:**
- Create: `skills/cv/generation-cv-docx/references/template-minimaliste.md`

- [ ] **Étape 1 : Créer le fichier**

Créer `skills/cv/generation-cv-docx/references/template-minimaliste.md` :

````markdown
# Template Minimaliste ATS-Safe — CV DOCX

## Caractéristiques
- Mise en page : colonne unique · Police : Arial (sans-serif)
- Couleur : noir `#111111` · Photo : non (incompatible ATS)
- Cible : universel, compatible parseurs ATS
- Contrainte : pas de tableaux, pas d'images, pas de couleurs, pas de zones de texte

## Preamble

```python
from docx import Document
from docx.shared import Pt, Cm, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml.ns import qn
from docx.oxml import OxmlElement

doc = Document()
for s in doc.sections:
    s.top_margin = Cm(2); s.bottom_margin = Cm(2)
    s.left_margin = Cm(2.5); s.right_margin = Cm(2.5)
```

## En-tête (texte brut, ATS-compatible)

```python
def entete(doc, identite):
    p = doc.add_paragraph()
    r = p.add_run(f"{identite['prenom']} {identite['nom']}")
    r.bold = True; r.font.size = Pt(16); r.font.name = 'Arial'
    if identite.get('titre'):
        doc.add_paragraph(identite['titre']).runs[0].font.size = Pt(11)
    coords = [x for x in [
        identite.get('email'), identite.get('telephone'),
        identite.get('localisation')
    ] if x]
    if coords:
        doc.add_paragraph(' | '.join(coords)).runs[0].font.size = Pt(9)
    p_sep = doc.add_paragraph()
    pBdr = OxmlElement('w:pBdr')
    bottom = OxmlElement('w:bottom')
    bottom.set(qn('w:val'), 'single'); bottom.set(qn('w:sz'), '6')
    bottom.set(qn('w:color'), '111111')
    pBdr.append(bottom)
    p_sep._p.get_or_add_pPr().append(pBdr)
```

## Titre de section (simple, uppercase, Arial)

```python
def titre_section(doc, texte):
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(10)
    p.paragraph_format.space_after = Pt(4)
    r = p.add_run(texte.upper())
    r.bold = True; r.font.size = Pt(11); r.font.name = 'Arial'
    pBdr = OxmlElement('w:pBdr')
    bottom = OxmlElement('w:bottom')
    bottom.set(qn('w:val'), 'single'); bottom.set(qn('w:sz'), '4')
    bottom.set(qn('w:color'), '111111')
    pBdr.append(bottom)
    p._p.get_or_add_pPr().append(pBdr)
```

## Expériences (bullets texte simples, ATS-safe)

```python
def experiences(doc, exps):
    if not exps: return
    titre_section(doc, 'Expériences professionnelles')
    for e in exps:
        p = doc.add_paragraph()
        p.paragraph_format.space_before = Pt(6)
        r = p.add_run(f"{e.get('poste','')} — {e.get('entreprise','')}")
        r.bold = True; r.font.size = Pt(11)
        dates = f"{e.get('date_debut','')}–{e.get('date_fin','présent')}"
        if e.get('localisation'): dates += f" · {e['localisation']}"
        p.add_run(f"  |  {dates}").italic = True
        if e.get('description'):
            doc.add_paragraph(e['description']).paragraph_format.space_after = Pt(2)
        for real in e.get('realisations', []):
            pb = doc.add_paragraph()
            pb.paragraph_format.left_indent = Pt(12)
            pb.add_run(f"• {real.get('texte','')}").font.size = Pt(10)
```

## Appel final

```python
entete(doc, profil['identite'])
if profil.get('resume'):
    titre_section(doc, 'Profil professionnel')
    doc.add_paragraph(profil['resume'])
experiences(doc, profil.get('experiences', []))
# formations, compétences, langues — même pattern que experiences()
doc.save('cv-minimaliste.docx')
print('cv-minimaliste.docx généré.')
```
````

- [ ] **Étape 2 : Valider la contrainte CI**

```bash
wc -l skills/cv/generation-cv-docx/references/template-minimaliste.md
```
Résultat attendu : nombre ≤ 150

- [ ] **Étape 3 : Commit**

```bash
git add skills/cv/generation-cv-docx/references/template-minimaliste.md
git commit -m "feat(cv-docx): add template-minimaliste reference (ATS-safe)"
```

---

## Task 6 — Créer template-wevalue.md (stub)

**Files:**
- Create: `skills/cv/generation-cv-docx/references/template-wevalue.md`

- [ ] **Étape 1 : Créer le fichier**

Créer `skills/cv/generation-cv-docx/references/template-wevalue.md` :

```markdown
# Template WeValue — CV DOCX (STUB)

## Statut

Ce template est **en attente de la charte graphique WeValue**.
Ne pas générer de code avec ce template.

## Comportement attendu du skill

Quand l'utilisateur sélectionne `wevalue`, afficher le message suivant
et lui demander de choisir un autre template :

> "Le template WeValue est en cours de développement — la charte graphique
> (couleurs, police, logo) n'a pas encore été fournie.
> Choisissez un des templates disponibles : **classique**, **moderne**
> ou **minimaliste**."

## Instructions pour l'implémentation future

Quand la charte WeValue sera disponible, remplacer ce fichier par le
contenu complet du template en suivant la même structure que
`template-classique.md` ou `template-moderne.md`, et mettre à jour :

1. La section `## wevalue` dans `infos-complementaires.md`
   (ajouter les champs requis : linkedin_url, photo, etc.)
2. Le menu de sélection dans `SKILL.md`
   (retirer la mention `[en cours de développement]`)

Informations attendues de la charte :
- Couleur primaire et secondaire (hex)
- Police(s) officielle(s)
- Nombre de colonnes et proportions
- Style des en-têtes et séparateurs
- Logo (chemin, position, taille) — si applicable
```

- [ ] **Étape 2 : Valider la contrainte CI**

```bash
wc -l skills/cv/generation-cv-docx/references/template-wevalue.md
```
Résultat attendu : nombre ≤ 150

- [ ] **Étape 3 : Commit**

```bash
git add skills/cv/generation-cv-docx/references/template-wevalue.md
git commit -m "feat(cv-docx): add template-wevalue stub"
```

---

## Task 7 — Mettre à jour SKILL.md

**Files:**
- Modify: `skills/cv/generation-cv-docx/SKILL.md`

- [ ] **Étape 1 : Lire le fichier actuel**

```bash
cat skills/cv/generation-cv-docx/SKILL.md
```

- [ ] **Étape 2 : Remplacer le contenu intégralement**

Écrire `skills/cv/generation-cv-docx/SKILL.md` avec le contenu suivant :

```markdown
---
name: generation-cv-docx
description: >
  Génère un ou plusieurs CV au format DOCX depuis un profil YAML normalisé.
  Propose 4 templates : classique (corporate), moderne (bicolonne + photo opt.),
  minimaliste (ATS-safe), wevalue (à venir). Pour plusieurs templates, parallélise
  la génération via sous-agents (skill orchestration-agents). Requiert Python 3.x
  + python-docx (+ Pillow pour la photo).
---

# Génération de CV DOCX — Point d'entrée

## Modèle

**`claude-haiku-4-5`** par défaut — tâche mécanique : mapping YAML → python-docx.
**`claude-sonnet-4-6`** si le profil est incomplet et nécessite un jugement éditorial
sur les champs manquants ou le contenu à rédiger.

---

## Étape 1 — Sélection du ou des templates

Si les templates ne sont pas précisés dans la demande, afficher :

> "Quel(s) template(s) souhaitez-vous ? (sélection multiple possible)
> - **classique** : sobre, colonne unique, serif, idéal corporate / conseil / finance
> - **moderne** : bicolonne avec sidebar colorée + photo optionnelle, idéal tech / startup
> - **minimaliste** : noir & blanc, colonne unique, 100 % lisible par les ATS
> - **wevalue** : [en cours de développement — charte WeValue à venir]"

**Si WeValue est sélectionné** : afficher le message de `template-wevalue.md`
et demander de choisir parmi classique / moderne / minimaliste.

**Compagnon visuel** : si disponible dans la session, proposer de l'activer
pour afficher les aperçus de templates avant le choix.

Charger après sélection :
- `references/shared-patterns.md`
- `references/template-<nom>.md` pour chaque template retenu
- `references/infos-complementaires.md`

---

## Étape 2 — Collecte des infos complémentaires (une seule passe)

1. Lire dans `infos-complementaires.md` les sections de **tous** les templates sélectionnés
2. Calculer l'**union** des champs requis (dédupliqués — ex : `linkedin_url` n'est
   demandé qu'une fois même si classique et moderne sont tous deux sélectionnés)
3. Identifier les champs absents du profil YAML fourni
4. Poser les questions pour les champs manquants en **une seule passe**
   (en bloc si ≤ 3 champs, un par un si > 3)
5. Si `moderne` figure dans la sélection : demander si une photo doit être incluse ;
   si oui, demander le chemin absolu (`.jpg` ou `.png`)
6. Tout champ non fourni → valeur `None` → le bloc est omis dans le script (`if valeur:`)

---

## Étape 3 — Génération du ou des scripts Python

### Cas A — template unique

Générer directement `generer_cv_<template>.py` complet entre triple backticks ` ```python `.
Profil embarqué en dictionnaire Python (pas de lecture YAML externe).

### Cas B — templates multiples

Invoquer le skill `orchestration-agents` pour dispatcher un sous-agent par template
en parallèle. Chaque sous-agent reçoit :
- Le profil YAML complet (dictionnaire Python sérialisé)
- Les infos complémentaires collectées (linkedin_url, site_web, github_url, chemin_photo)
- Le template cible (une seule valeur par agent)
- Instruction : générer `generer_cv_<template>.py` selon `template-<template>.md`

Afficher les scripts générés séquentiellement avec leurs instructions d'exécution.

### Règles communes

- Profil embarqué en dictionnaire Python (jamais de lecture YAML externe)
- `if valeur:` sur **tout** champ optionnel — ne jamais afficher un label sans valeur
- Photo (template `moderne`) : `python-docx` + `Pillow`, table 2 colonnes en en-tête
- Nom du fichier de sortie : `cv-<template>.docx`

---

## Étape 4 — Instructions d'exécution

Après chaque script généré, toujours indiquer :

```
pip install python-docx          # toujours requis
pip install Pillow               # uniquement pour le template moderne avec photo
python generer_cv_<template>.py
# Résultat : cv-<template>.docx dans le répertoire courant
# Pour convertir en PDF → skill generation-cv-pdf
```
```

- [ ] **Étape 3 : Valider la présence du frontmatter**

```bash
head -5 skills/cv/generation-cv-docx/SKILL.md
```
Résultat attendu : les lignes `---`, `name: generation-cv-docx`, `description:` doivent être présentes.

- [ ] **Étape 4 : Commit**

```bash
git add skills/cv/generation-cv-docx/SKILL.md
git commit -m "feat(cv-docx): rewrite SKILL.md — multi-templates, collecte unifiée, sous-agents"
```

---

## Task 8 — Validation CI et mise à jour CLAUDE.md

**Files:**
- Read: `.github/workflows/validate.yml`
- Modify: `CLAUDE.md` (table des skills)

- [ ] **Étape 1 : Vérifier tous les fichiers de référence ≤ 150 lignes**

```bash
for f in skills/cv/generation-cv-docx/references/*.md; do
  count=$(wc -l < "$f")
  echo "$count $f"
  [ "$count" -gt 150 ] && echo "  ⚠ DÉPASSE 150 LIGNES"
done
```
Résultat attendu : tous les counts ≤ 150, aucune ligne `⚠ DÉPASSE`.

- [ ] **Étape 2 : Vérifier que SKILL.md est présent**

```bash
ls skills/cv/generation-cv-docx/SKILL.md
```
Résultat attendu : fichier affiché sans erreur.

- [ ] **Étape 3 : Mettre à jour la description du skill dans CLAUDE.md**

Dans `CLAUDE.md`, localiser la ligne :
```
| `cv` | `generation-cv-docx` | Generate CV DOCX via python-docx script |
```
Et la remplacer par :
```
| `cv` | `generation-cv-docx` | Multi-templates DOCX (classique, moderne, minimaliste, wevalue-stub) ; collecte unifiée ; parallélisation sous-agents |
```

- [ ] **Étape 4 : Commit final**

```bash
git add CLAUDE.md
git commit -m "docs: update CLAUDE.md — generation-cv-docx multi-templates"
```

- [ ] **Étape 5 (optionnel) : Synchroniser vers l'environnement Claude Code**

```bash
./scripts/sync-to-claude.sh
```
