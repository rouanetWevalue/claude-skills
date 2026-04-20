# Patterns python-pptx — Génération CV PPT

## Imports et initialisation

```python
from pptx import Presentation
from pptx.util import Inches, Pt, Cm
from pptx.dml.color import RGBColor
from pptx.enum.text import PP_ALIGN
from pptx.enum.shapes import MSO_SHAPE_TYPE

prs = Presentation()
prs.slide_width = Inches(13.33)   # 16:9 Widescreen
prs.slide_height = Inches(7.5)

BLEU  = RGBColor(0x1F, 0x49, 0x7D)
GRIS  = RGBColor(0x40, 0x40, 0x40)
BLANC = RGBColor(0xFF, 0xFF, 0xFF)

def slide_vierge(prs):
    """Slide avec layout blanc (index 6 = blank)."""
    layout = prs.slide_layouts[6]
    return prs.slides.add_slide(layout)

def zone_texte(slide, texte, left, top, width, height,
               taille=12, gras=False, couleur=GRIS,
               alignement=PP_ALIGN.LEFT):
    txBox = slide.shapes.add_textbox(left, top, width, height)
    tf = txBox.text_frame
    tf.word_wrap = True
    p = tf.paragraphs[0]
    p.alignment = alignement
    run = p.add_run()
    run.text = texte
    run.font.size = Pt(taille)
    run.font.bold = gras
    run.font.color.rgb = couleur
    return txBox
```

## Slide 1 — Titre / Identité

```python
def slide_titre(prs, identite, resume):
    slide = slide_vierge(prs)
    W, H = prs.slide_width, prs.slide_height

    # Bandeau de fond bleu (rectangle gauche)
    # add_shape(1, ...) : entier 1 = rectangle (MSO_SHAPE_TYPE.RECTANGLE
    # concerne le type d'une shape existante, pas l'arg de add_shape)
    bg = slide.shapes.add_shape(1,
        0, 0, Inches(4.5), H)
    bg.fill.solid()
    bg.fill.fore_color.rgb = BLEU
    bg.line.fill.background()

    # Nom (colonne gauche)
    zone_texte(slide,
        f"{identite['prenom']}\n{identite['nom']}",
        Inches(0.3), Inches(1.5), Inches(3.8), Inches(1.8),
        taille=28, gras=True, couleur=BLANC)

    # Titre professionnel
    zone_texte(slide,
        identite.get('titre', ''),
        Inches(0.3), Inches(3.4), Inches(3.8), Inches(0.8),
        taille=13, couleur=BLANC)

    # Coordonnées
    coords = "\n".join(filter(None, [
        identite.get('email'), identite.get('telephone'),
        identite.get('localisation'), identite.get('linkedin_url')
    ]))
    zone_texte(slide, coords,
        Inches(0.3), Inches(4.4), Inches(3.8), Inches(1.8),
        taille=10, couleur=BLANC)

    # Résumé (colonne droite)
    if resume:
        zone_texte(slide, resume,
            Inches(5.0), Inches(1.5), Inches(7.8), Inches(5.0),
            taille=11, couleur=GRIS)
```

## Slide 2 — Compétences (tableau par catégorie)

```python
def slide_competences(prs, competences, langues, certifications):
    slide = slide_vierge(prs)
    zone_texte(slide, "COMPÉTENCES & LANGUES",
        Inches(0.5), Inches(0.2), Inches(12), Inches(0.5),
        taille=16, gras=True, couleur=BLEU)

    # Regrouper par catégorie
    from collections import defaultdict
    cats = defaultdict(list)
    for c in (competences or []):
        cats[c.get('categorie', 'Autres')].append(
            f"{c['nom']} ({c.get('niveau','')})")

    rows = len(cats) + 1
    table = slide.shapes.add_table(
        rows, 2, Inches(0.5), Inches(0.9),
        Inches(8), Inches(0.4 * rows)).table
    table.cell(0, 0).text = "Catégorie"
    table.cell(0, 1).text = "Compétences"
    for i, (cat, items) in enumerate(cats.items(), start=1):
        table.cell(i, 0).text = cat
        table.cell(i, 1).text = ", ".join(items)

    # Langues + Certifications à droite
    if langues:
        lang_txt = "\n".join(
            f"• {l['langue']} : {l.get('niveau','')}" for l in langues)
        zone_texte(slide, "LANGUES\n" + lang_txt,
            Inches(9.0), Inches(0.9), Inches(3.8), Inches(2.5),
            taille=11, couleur=GRIS)
    if certifications:
        cert_txt = "\n".join(
            f"• {c['nom']} ({c.get('date','')})" for c in certifications)
        zone_texte(slide, "CERTIFICATIONS\n" + cert_txt,
            Inches(9.0), Inches(3.8), Inches(3.8), Inches(2.5),
            taille=11, couleur=GRIS)
```

## Sauvegarde

```python
slide_titre(prs, profil['identite'], profil.get('resume'))
slide_competences(prs,
    profil.get('competences'), profil.get('langues'),
    profil.get('certifications'))
# Slide 3 : expériences/projets à générer avec zone_texte + bullets si besoin

prs.save("cv_profil.pptx")
print("cv_profil.pptx généré avec succès.")
```
