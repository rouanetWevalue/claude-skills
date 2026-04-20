# Patterns python-docx — Génération CV DOCX

## Imports et initialisation

```python
from docx import Document
from docx.shared import Pt, Cm, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml.ns import qn
from docx.oxml import OxmlElement

doc = Document()

# Marges (2 cm partout)
for section in doc.sections:
    section.top_margin = Cm(2)
    section.bottom_margin = Cm(2)
    section.left_margin = Cm(2.5)
    section.right_margin = Cm(2.5)
```

## Helpers de styles

```python
def ajouter_titre_section(doc, texte):
    """Titre de section : H2, gras, couleur bleue, bordure basse."""
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(10)
    p.paragraph_format.space_after = Pt(4)
    run = p.add_run(texte.upper())
    run.bold = True
    run.font.size = Pt(12)
    run.font.color.rgb = RGBColor(0x1F, 0x49, 0x7D)
    # Bordure basse
    pPr = p._p.get_or_add_pPr()
    pBdr = OxmlElement('w:pBdr')
    bottom = OxmlElement('w:bottom')
    bottom.set(qn('w:val'), 'single')
    bottom.set(qn('w:sz'), '6')
    bottom.set(qn('w:color'), '1F497D')
    pBdr.append(bottom)
    pPr.append(pBdr)

def ajouter_sous_titre(doc, poste, entreprise, dates, lieu):
    """Ligne poste + entreprise (gras) et dates + lieu (italique)."""
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(6)
    p.paragraph_format.space_after = Pt(2)
    run_poste = p.add_run(f"{poste} — {entreprise}")
    run_poste.bold = True
    run_poste.font.size = Pt(11)
    p.add_run(f"  |  {dates}  ·  {lieu}").italic = True

def ajouter_bullet(doc, texte, metrique=None):
    """Bullet point, métrique en gras si fournie."""
    p = doc.add_paragraph(style='List Bullet')
    p.paragraph_format.space_after = Pt(2)
    if metrique:
        idx = texte.find(metrique)
        if idx >= 0:
            p.add_run(texte[:idx])
            p.add_run(metrique).bold = True
            p.add_run(texte[idx + len(metrique):])
        else:
            p.add_run(texte)
            p.add_run(f" ({metrique})").bold = True
    else:
        p.add_run(texte)
```

## En-tête (identite)

```python
def ajouter_entete(doc, identite):
    # Nom
    p_nom = doc.add_paragraph()
    p_nom.alignment = WD_ALIGN_PARAGRAPH.CENTER
    run = p_nom.add_run(f"{identite['prenom']} {identite['nom']}")
    run.bold = True
    run.font.size = Pt(18)
    # Titre
    p_titre = doc.add_paragraph()
    p_titre.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p_titre.add_run(identite.get('titre', '')).font.size = Pt(12)
    # Coordonnées sur une ligne
    coords = [x for x in [
        identite.get('email'), identite.get('telephone'),
        identite.get('localisation'), identite.get('linkedin_url')
    ] if x]
    p_coords = doc.add_paragraph(" | ".join(coords))
    p_coords.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p_coords.runs[0].font.size = Pt(9)
```

## Section Expériences (exemple complet)

```python
def ajouter_experiences(doc, experiences):
    if not experiences:
        return
    ajouter_titre_section(doc, "Expériences professionnelles")
    for exp in experiences:
        dates = f"{exp.get('date_debut','')} – {exp.get('date_fin','présent')}"
        ajouter_sous_titre(doc,
            exp.get('poste', ''), exp.get('entreprise', ''),
            dates, exp.get('localisation', ''))
        if exp.get('description'):
            p = doc.add_paragraph(exp['description'])
            p.paragraph_format.space_after = Pt(2)
        for real in exp.get('realisations', []):
            ajouter_bullet(doc, real.get('texte', ''),
                           real.get('metrique'))
        if exp.get('competences_utilisees'):
            p = doc.add_paragraph()
            p.add_run("Compétences : ").bold = True
            p.add_run(", ".join(exp['competences_utilisees']))
```

## Sauvegarde

```python
# Appel final dans le script
ajouter_entete(doc, profil['identite'])
if profil.get('resume'):
    ajouter_titre_section(doc, "Résumé")
    doc.add_paragraph(profil['resume'])
ajouter_experiences(doc, profil.get('experiences', []))
# ... idem pour formations, competences, langues, certifications,
#     projets, publications, distinctions, centres_interet

doc.save("cv.docx")
print("cv.docx généré avec succès.")
```
