# Compilation et conversion — Commandes et troubleshooting

## LaTeX → PDF

### Commandes de compilation

**pdflatex** (templates standards : moderncv, etc.)
```bash
pdflatex cv.tex
```

**xelatex** (templates avec polices personnalisées : AltaCV, fontspec)
```bash
xelatex cv.tex
```

> Règle de choix : si le preamble contient `\usepackage{fontspec}` ou charge des polices
> système (ex. `\setmainfont{...}`), utiliser `xelatex`. Sinon, `pdflatex` suffit.

**Double compilation** (si le CV contient des références bibliographiques ou des liens internes)
```bash
pdflatex cv.tex && pdflatex cv.tex
```

**latexmk** (alternative automatique — détecte le nombre de passes nécessaires)
```bash
latexmk -pdf cv.tex        # avec pdflatex
latexmk -xelatex cv.tex   # avec xelatex
```

---

### Troubleshooting LaTeX (MiKTeX / Windows)

**Packages manquants**
MiKTeX installe les packages manquants à la volée (option activée par défaut).
Si la compilation se bloque en attente de confirmation :
- Ouvrir MiKTeX Console → Settings → cocher "Always install missing packages on-the-fly"
- Ou pré-installer les packages : `miktex-console` → Packages → rechercher et installer

**Erreur de compilation — lire le log**
```bash
# Le fichier cv.log contient les détails de l'erreur
# Chercher les lignes commençant par "!" pour localiser le problème
```
Ne pas consulter `cv.aux` pour le diagnostic — uniquement `cv.log`.

**Erreurs courantes**
| Symptôme | Cause probable | Solution |
|---|---|---|
| `! LaTeX Error: File 'xxx.sty' not found` | Package absent | Installer via MiKTeX Console |
| `! Font ... not found` | Police système manquante | Passer de `xelatex` à `pdflatex`, ou installer la police |
| `! Missing $ inserted` | Caractère spécial non échappé | Échapper `&` `%` `$` `#` `_` `{` `}` |
| PDF vide ou tronqué | Compilation interrompue | Supprimer `cv.aux`, `cv.log`, relancer |

---

## DOCX → PDF

### Commande principale — docx2pdf (Python)

**Prérequis** : Python 3.x + Microsoft Word installé (Word est requis — docx2pdf pilote Word via COM)

```bash
pip install docx2pdf
```

```python
from docx2pdf import convert
convert("cv.docx", "cv.pdf")
```

Ou en ligne de commande :
```bash
python -m docx2pdf cv.docx cv.pdf
```

---

### Alternative — LibreOffice (si Word n'est pas disponible)

```bash
soffice --headless --convert-to pdf cv.docx
```

> LibreOffice doit être installé. Téléchargement : https://www.libreoffice.org/download/
> Le rendu peut différer légèrement de Word (polices, espacements).

---

### Troubleshooting docx2pdf

**Erreurs courantes**
| Symptôme | Cause probable | Solution |
|---|---|---|
| `ImportError: No module named 'docx2pdf'` | Package non installé | `pip install docx2pdf` |
| `DocxPdfConversionException` | Word non installé ou non démarré | Vérifier que Word est installé et fonctionnel |
| PDF avec mise en forme incorrecte | Polices manquantes sur le système | Intégrer les polices dans le DOCX ou utiliser des polices système standards |
| Fichier PDF non créé | Chemin de sortie inexistant | Vérifier que le répertoire de destination existe |

**Vérifier que Word fonctionne**
```python
import win32com.client
word = win32com.client.Dispatch("Word.Application")
print(word.Version)  # Affiche la version Word si OK
word.Quit()
```
