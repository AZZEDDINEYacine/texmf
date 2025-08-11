\LoadClass[a4,oneside]{article}
\usepackage{preamble}
\usepackage{graphicx}
\usepackage{tikz}
\usepackage{lipsum}
\pagestyle{fancy}
% Always typeset math in display style
\newcommand{\hmwkTitle}{1st\ hw}
\newcommand{\hmwkDueDate}{}
\newcommand{\hmwkClass}{Functional Analysis}
\newcommand{\hmwkClassTime}{Banach Space}
\newcommand{\hmwkAuthorName}{}
\newcommand{\hmwkSubTitle}{prerequisite problem set}
\newcommand{\hmwkSummary}{}
\newcommand{\dueDate}{Translated Headline}
\newcommand{\university}{National Higher School of Mathematics}
\newcommand{\backgroundimg}{background.png}

\newcounter{problemCounter}
\setcounter{problemCounter}{1}

\lhead{\hmwkClass}
\chead{\hmwkTitle}
\rhead{\firstxmark}
\lfoot{\lastxmark}
\cfoot{\thepage}

\author{}
\date{}

\setlength\parindent{0pt}

%
% Title Page
%

\newcommand{\leaves}{
    \begin{tikzpicture}[scale=0.5]
        \draw[green!50!black] (0,0) .. controls (1,2) and (2,2) .. (3,0) .. controls (2,-1) and (1,-1) .. (0,0);
        \draw[green!50!black] (1,0) .. controls (2,2) and (3,2) .. (4,0) .. controls (3,-1) and (2,-1) .. (1,0);
        \draw[green!50!black] (2,0) .. controls (3,2) and (4,2) .. (5,0) .. controls (4,-1) and (3,-1) .. (2,0);
    \end{tikzpicture}
}

\title{
    \newenvironment{myfont}{\fontfamily{phv}\selectfont}{\par}

    \thispagestyle{empty}
    \myfont
    \raggedright
    \begin{figure} [H]
        \centering
        \begin{minipage}[t]{.45\linewidth}
            \raggedright
            \includegraphics[height=3cm]{eureka.logo.jpg}
        \end{minipage}%
        \hfill
        \begin{minipage}[t]{.45\linewidth}
            \raggedleft
            \includegraphics[height=3cm]{nhsm.logo.2.png}
        \end{minipage}
    \end{figure}


    % Adds background picture. Delete code if no background picture is wanted.
    \begin{tikzpicture}[overlay, remember picture]
    \node[anchor=south west, 
        xshift=-0.2cm, 
        yshift=-0.2cm] 
        at (current page.south west)
        {\includegraphics[width = \paperwidth]{\backgroundimg}}; 
    \end{tikzpicture}

    \vspace{2cm}
    \par\noindent
    \Huge\textbf{\hmwkClass}
    \vspace{0.2cm}
    \LARGE\par\noindent- \hmwkTitle\hfill \noindent\small Due: \hmwkDueDate\\
    \vspace{0.2cm}
    \rule[0.3cm]{\linewidth}{2pt}
    \large\noindent\textit{\hmwkSummary}\\
    \vspace{0.2cm}
    \vspace{4 cm}
}


% custom envs

\renewcommand{\labelenumi}{\alph{enumi}.}
\setcounter{secnumdepth}{0}
\newcounter{partCounter}
\nobreak\extramarks{Problem \arabic{problemCounter}}{}\nobreak{}

\newcommand{\enterProblemHeader}[1]{
    \nobreak\extramarks{}{Problem \arabic{#1} continued on next page\ldots}\nobreak{}
    \nobreak\extramarks{Problem \arabic{#1} (continued)}{Problem \arabic{#1} continued on next page\ldots}\nobreak{}
}

\newcommand{\exitProblemHeader}[1]{
    \nobreak\extramarks{Problem \arabic{#1} (continued)}{Problem \arabic{#1} continued on next page\ldots}\nobreak{}
    \stepcounter{#1}
    \nobreak\extramarks{Problem \arabic{#1}}{}\nobreak{}
}

\newenvironment{problem}[1][-1]{
    \ifnum#1>0
        \setcounter{problemCounter}{#1}
    \fi
    \subsection{Problem \arabic{problemCounter}}
    \setcounter{partCounter}{1}
    \enterProblemHeader{problemCounter}
}{
    \exitProblemHeader{problemCounter}
}

\newenvironment{exercise}[1][\ensuremath{\blacktriangleright}]{%
  % begin code
  \par                        % end previous paragraph
  \vspace{3pt}                % space above
  \noindent                   % start at left margin
  {\bfseries #1\ }%           % the head symbol, bold, followed by a space
  \begingroup
    \addtolength{\leftskip}{1em}% indent whole body by 1em
    \ignorespaces             % ignore spaces/newline after \begin{exercise}
}{%
  % end code
  \par                        % end current paragraph inside env
  \endgroup
  \vspace{3pt}                % space below
}

\setlist[enumerate]{label={\arabic*.}}