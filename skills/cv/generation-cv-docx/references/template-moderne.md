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
BLANC = RGBColor(0xFF, 0xFF, 0xFF)
VERT = RGBColor(0x2D, 0x6A, 0x4F)

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
