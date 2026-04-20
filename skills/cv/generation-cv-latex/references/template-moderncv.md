# Template moderncv — Référence LaTeX

## Preamble complet

```latex
\documentclass[11pt,a4paper]{moderncv}

% Style : 'classic' (icônes + colonne gauche) ou 'banking' (lignes horizontales)
\moderncvstyle{classic}   % remplacer par 'banking' si demandé

% Couleur principale
\moderncvcolor{blue}      % blue | orange | green | red | purple | grey | black

% Encodage
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage[french]{babel}

% Marges
\usepackage[scale=0.85]{geometry}

% Conditionnel (pour URLs optionnelles)
\usepackage{ifthen}
```

## Structure du document

```latex
\begin{document}

% En-tête (identite)
\name{{prenom}}{{nom}}
\title{{titre}}
\address{{localisation}}{}{}
\phone[mobile]{{telephone}}
\email{{email}}
\social[linkedin]{{linkedin_url}}
\social[github]{{github_url}}
\homepage{{site_web}}

\makecvtitle

% Expériences (experiences[])
\section{Expériences professionnelles}

\cventry{{date_debut}--{date_fin}}  % dates
        {{poste}}                    % intitulé
        {{entreprise}}              % entreprise
        {{localisation}}            % lieu
        {{type_contrat}}            % type
        {                           % description
          {description}
          \begin{itemize}
            \item {realisation_1.texte} \textbf{({realisation_1.metrique})}
            \item {realisation_2.texte}
          \end{itemize}
        }

% Formations (formations[])
\section{Formations}

\cventry{{date_debut}--{date_fin}}
        {{diplome} en {domaine}}
        {{etablissement}}
        {}{}
        {\textit{{mention}} — {description}}

% Compétences (competences[] regroupées par categorie)
\section{Compétences}

\cvitem{{categorie_1}}{{competence_1}, {competence_2}, ...}
\cvitem{{categorie_2}}{{competence_3}, ...}

% Langues (langues[])
\section{Langues}

\cvitemwithcomment{{langue}}{{niveau}}{}

% Certifications (certifications[])
\section{Certifications}

\cvitem{{date}}{\textbf{{nom}} — {organisme}
  \ifthenelse{\equal{{url}}{}}{}{\ (\href{{url}}{lien})}}

% Projets (projets[])
\section{Projets}

\cvitem{{nom}}{{description}
  Technologies : \textit{{technologies}}
  \ifthenelse{\equal{{url}}{}}{}{\ — \href{{url}}{lien}}}

% Publications (publications[])
\section{Publications}

\cvitem{{date}}{\textbf{{titre}} — \textit{{support}}
  \ifthenelse{\equal{{url}}{}}{}{\ (\href{{url}}{lien})}}

% Distinctions (distinctions[])
\section{Distinctions}

\cvitem{{date}}{\textbf{{titre}} — {organisme}}

% Centres d'intérêt (centres_interet[])
\section{Centres d'intérêt}

\cvitem{}{{{centres_interet_liste}}}

\end{document}
```

## Différences classic vs banking

| Aspect | `classic` | `banking` |
|---|---|---|
| En-tête | Photo optionnelle + bloc info | Bloc info centré, typographique |
| Sections | Icône + texte à gauche | Ligne de séparation horizontale |
| Usage | Profils généralistes, consulting | Finance, droit, corporate |

## Règles moderncv

- Grouper les `competences[]` par `categorie` → une ligne `\cvitem` par catégorie
- Résumé : `\section{Résumé}\cvitem{}{...}` ou `\begin{quote}...\end{quote}`
- Sections vides : commenter le bloc `%% section vide %%`
- Photo : ajouter `\photo[64pt][0.4pt]{photo.jpg}` avant `\makecvtitle` si disponible
- Package moderncv disponible sur CTAN, inclus dans MiKTeX/TeX Live
