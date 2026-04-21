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
