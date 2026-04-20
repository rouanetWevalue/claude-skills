# Template AltaCV — Référence LaTeX

## Preamble complet

```latex
\documentclass[10pt,a4paper,ragged2e,withhyper]{altacv}

% Marges : colonne principale / barre latérale
\geometry{left=1cm,right=1cm,top=1.5cm,bottom=1.5cm,
          columnsep=1.2cm}

% Encodage
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage[french]{babel}

% Police
\usepackage[default]{lato}

% Couleurs
\definecolor{VividPurple}{HTML}{3E0097}
\definecolor{SlateGrey}{HTML}{2E2E2E}
\definecolor{LightGrey}{HTML}{666666}
\colorlet{heading}{VividPurple}
\colorlet{headingrule}{VividPurple}
\colorlet{accent}{VividPurple}
\colorlet{emphasis}{SlateGrey}
\colorlet{body}{LightGrey}

% Largeur de la barre latérale
\columnratio{0.6}
```

## Structure du document

```latex
\begin{document}

% En-tête (identite)
\name{{prenom} {nom}}
\tagline{{titre}}
\personalinfo{%
  \email{{email}}
  \phone{{telephone}}
  \location{{localisation}}
  \linkedin{{linkedin_url}}   % lien cliquable
  \github{{github_url}}
}

\makecvheader

% Mise en page bicolonne
\begin{paracol}{2}

%% COLONNE GAUCHE %%

\cvsection{Expériences professionnelles}

\cvevent{{poste}}{{entreprise}}{{date_debut}--{date_fin}}{{localisation}}
{description}
\begin{itemize}
  \item {realisation_1.texte} \textbf{({realisation_1.metrique})}
  \item {realisation_2.texte}
\end{itemize}
\divider

\cvsection{Formations}

\cvevent{{diplome} en {domaine}}{{etablissement}}{{date_debut}--{date_fin}}{}
{description} — \textit{{mention}}
\divider

\cvsection{Projets}

\cvevent{{nom}}{}{}{} 
{description} (\href{{url}}{lien})\\
\textit{Technologies :} {technologies}

%% PASSAGE COLONNE DROITE %%
\switchcolumn

\cvsection{Résumé}
\begin{quote}
{resume}
\end{quote}

\cvsection{Compétences}

\cvtag{{competence_1}}   % répéter pour chaque compétence
\cvtag{{competence_2}}

\cvsection{Langues}

\cvskill{{langue}}{5}    % niveau 1–5 → Scolaire→Natif

\cvsection{Certifications}

\cvevent{{nom}}{{organisme}}{{date}}{}

\cvsection{Distinctions}

\cvevent{{titre}}{{organisme}}{{date}}{}

\cvsection{Centres d'intérêt}
\cvtag{{centre_1}}

\end{paracol}
\end{document}
```

## Mapping niveaux de langue → `\cvskill`

| Niveau profil | Valeur `\cvskill` |
|---|---|
| Natif | 5 |
| Courant (C1-C2) | 4 |
| Professionnel (B2) | 3 |
| Scolaire (A1-B1) | 2 |

## Règles AltaCV

- `\divider` entre chaque `\cvevent` d'une même section
- `\cvtag` pour les compétences et centres d'intérêt (nuage de tags)
- Publications : `\cvevent{{titre}}{{support}}{{date}}{}` + `\href{{url}}{lien}`
- Sections vides : commenter le bloc `%% section vide %%`
- Package AltaCV disponible sur CTAN ou inclus dans MiKTeX
