% housebook.cls — the house book class: the printed book, set with XeLaTeX.
%
% Template-owned: `copier update` merges improvements into it. Page-design choices are never
% made here: they are class options in typeset/src/book.tex, chosen by the author and recorded
% in typeset/src/page-design.md. Every macro, and when to use it, is in
% typeset/docs/reference/the-house-class.md.
%
% Why the name `housebook` and the base `report`: the name never shadows LaTeX's standard
% `book` class, so a Pandoc proof that asks for `book` still gets the standard one, and
% \documentclass{housebook} finds this file through the TEXINPUTS that `make print` sets.
% The class builds on `report` and adds the book's divisions itself (\frontmatter,
% \mainmatter, \backmatter), so every division is the house's own. Compiled without
% `make print`, \documentclass{housebook} is not found, which is the right failure.
%
% Options (key=value; each one a line in page-design.md):
%   trim=b-format|a-format|demy|royal|a5|us-trade|digest   page size = trim size (default demy)
%   trimwidth=…, trimheight=…   a custom trim (both, with units), which overrides trim=
%   inner= outer= top= bottom=  margins (lengths); defaults suit the trim
%   fontsize=10pt|11pt|12pt     body size (default 11pt)
%   mainfont=…  headingfont=…   installed typefaces; a missing one falls back with a warning
%   chapterstyle=centred|left|plain    the chapter opener (default centred)
%   chapterlabel=numeral|word|none     'Chapter 3', 'Chapter Three' or no label (numeral)
%   scenebreak=stars|asterism|fleuron|rule|space   the scene-break mark (default stars)
%   footnotes=hang|plain        number in a hanging box, or superscript (default hang)
%   dropcaps=true|false         whether \dropcap draws a drop capital (default true)
%   greekfont=…  hebrewfont=…   typefaces for \greek{} and \hebrew{}
%   final                       an open \dnote flag, or a character no font can draw, stops
%                               the print instead of showing in it (or printing as nothing)
\NeedsTeXFormat{LaTeX2e}[2020/10/01]
\ProvidesClass{housebook}[2026/10/03 v0.1.0 house book class]

\RequirePackage{iftex}
\ifXeTeX\else
  \ClassError{housebook}{The house book class needs XeLaTeX}%
    {Build the book with: make print}
\fi

% ── Options ───────────────────────────────────────────────────────────────────
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=house,prefix=house@}
\DeclareStringOption[demy]{trim}
\DeclareStringOption{trimwidth}
\DeclareStringOption{trimheight}
\DeclareStringOption{inner}
\DeclareStringOption{outer}
\DeclareStringOption{top}
\DeclareStringOption{bottom}
\DeclareStringOption[11pt]{fontsize}
\DeclareStringOption{mainfont}
\DeclareStringOption{headingfont}
\DeclareStringOption[centred]{chapterstyle}
\DeclareStringOption[numeral]{chapterlabel}
\DeclareStringOption[stars]{scenebreak}
\DeclareStringOption[hang]{footnotes}
\DeclareBoolOption[true]{dropcaps}
\DeclareStringOption{greekfont}
\DeclareStringOption{hebrewfont}
\DeclareBoolOption{final}
\DeclareDefaultOption{\ClassError{housebook}{Unknown class option `\CurrentOption'}%
  {The options are listed in typeset/docs/reference/the-house-class.md.}}
\ProcessKeyvalOptions*

\RequirePackage{etoolbox}
\def\house@oneof#1#2#3{% value, allowed list, option name
  \def\house@ok{0}%
  \@for\house@x:=#2\do{\ifdefstrequal{\house@x}{#1}{\def\house@ok{1}}{}}%
  \ifnum\house@ok=0 \ClassError{housebook}{#3=#1 is not one of: #2}%
    {See typeset/docs/reference/the-house-class.md.}\fi}
\house@oneof{\house@fontsize}{10pt,11pt,12pt}{fontsize}
\house@oneof{\house@chapterstyle}{centred,left,plain}{chapterstyle}
\house@oneof{\house@chapterlabel}{numeral,word,none}{chapterlabel}
\house@oneof{\house@scenebreak}{stars,asterism,fleuron,rule,space}{scenebreak}
\house@oneof{\house@footnotes}{hang,plain}{footnotes}

\edef\house@load{\noexpand\LoadClass[\house@fontsize,twoside,openright]{report}}
\house@load

% ── Trim and margins ─────────────────────────────────────────────────────────
\def\house@settrim#1#2#3{\def\house@tw{#1}\def\house@th{#2}\def\house@small{#3}}
\ifdefstring{\house@trim}{b-format}{\house@settrim{129mm}{198mm}{1}}{%
\ifdefstring{\house@trim}{a-format}{\house@settrim{110mm}{178mm}{1}}{%
\ifdefstring{\house@trim}{demy}{\house@settrim{138mm}{216mm}{0}}{%
\ifdefstring{\house@trim}{royal}{\house@settrim{156mm}{234mm}{0}}{%
\ifdefstring{\house@trim}{a5}{\house@settrim{148mm}{210mm}{0}}{%
\ifdefstring{\house@trim}{us-trade}{\house@settrim{6in}{9in}{0}}{%
\ifdefstring{\house@trim}{digest}{\house@settrim{5.5in}{8.5in}{1}}{%
  \ClassError{housebook}{trim=\house@trim is not a trim this class knows}%
    {Use b-format, a-format, demy, royal, a5, us-trade or digest, or give trimwidth= and trimheight=.}%
  \house@settrim{138mm}{216mm}{0}}}}}}}}
\ifx\house@trimwidth\@empty\else\ifx\house@trimheight\@empty\else
  \house@settrim{\house@trimwidth}{\house@trimheight}{0}\fi\fi
\ifnum\house@small=1
  \def\house@di{18mm}\def\house@do{13mm}\def\house@dt{15mm}\def\house@db{18mm}
\else
  \def\house@di{20mm}\def\house@do{15mm}\def\house@dt{18mm}\def\house@db{20mm}
\fi
\ifx\house@inner\@empty\let\house@inner\house@di\fi
\ifx\house@outer\@empty\let\house@outer\house@do\fi
\ifx\house@top\@empty\let\house@top\house@dt\fi
\ifx\house@bottom\@empty\let\house@bottom\house@db\fi
\RequirePackage{geometry}
\edef\house@geometry{\noexpand\geometry{paperwidth=\house@tw,paperheight=\house@th,
  inner=\house@inner,outer=\house@outer,top=\house@top,bottom=\house@bottom,
  headsep=5mm,footskip=8mm,includehead=false}}
\house@geometry

% ── Fonts ────────────────────────────────────────────────────────────────────
\RequirePackage{fontspec}
\defaultfontfeatures{Ligatures=TeX}
\def\house@font#1#2#3{% option value, command to define, role in the warning
  \ifx#1\@empty\else
    \IfFontExistsTF{#1}{\def\house@tmp{#2}\expandafter\house@tmp\expandafter{#1}}%
      {\ClassWarning{housebook}{The #3 typeface `#1' is not installed; keeping the default}}%
  \fi}
\house@font{\house@mainfont}{\setmainfont}{body}
\house@font{\house@headingfont}{\newfontfamily\house@headingfamily}{heading}
\ifdefined\house@headingfamily\else\let\house@headingfamily\rmfamily\fi
\newcommand\house@headface{\house@headingfamily}

% Theology: Greek and Hebrew run in their own typefaces when the options name them.
\TeXXeTstate=1
\house@font{\house@greekfont}{\newfontfamily\house@greekfamily}{Greek}
\house@font{\house@hebrewfont}{\newfontfamily\house@hebrewfamily}{Hebrew}
\newcommand\greek[1]{{\ifdefined\house@greekfamily\house@greekfamily\else\house@warnonce{greek}\fi
  #1}}
\newcommand\hebrew[1]{{\ifdefined\house@hebrewfamily\house@hebrewfamily\else\house@warnonce{hebrew}\fi
  \beginR #1\endR}}
\newcommand\house@warnonce[1]{\ifcsdef{house@warned@#1}{}{\global\csdef{house@warned@#1}{}%
  \ClassWarning{housebook}{\expandafter\string\csname #1\endcsname\space is used but no #1font= option
    is set; the body face may not have these letters}}}

% ── Constructed languages ────────────────────────────────────────────────────
% \conlang[slug]{word}: a romanised word, in italic. \conlangnative[slug][romanised]{text}: the
% word in the language's own script, from the font `make font` builds at build/fonts/<slug>.otf.
% With no font, the romanised form prints in italic instead, and the log says how to build it.
\newcommand\conlangstyle{\itshape}
\NewDocumentCommand\conlang{o m}{{\conlangstyle #2}}
\newcommand\house@nofont[1]{\ifcsdef{house@nofont@#1}{}{\global\csdef{house@nofont@#1}{}%
  \ClassWarning{housebook}{No font build/fonts/#1.otf: native-script words in #1 print as
    romanised italic. Build the font with: make font LANG=#1}}}
\NewDocumentCommand\conlangnative{o o m}{%
  \IfNoValueTF{#1}{#3}{%
    \IfFileExists{build/fonts/#1.otf}%
      {{\fontspec{#1.otf}[Path=build/fonts/]#3}}%
      {\house@nofont{#1}\IfNoValueTF{#2}{#3}{\conlang[#1]{#2}}}}}

% ── Chapter openers ──────────────────────────────────────────────────────────
\newcommand\house@numberword[1]{%
  \ifcase#1 Zero\or One\or Two\or Three\or Four\or Five\or Six\or Seven\or Eight\or Nine\or
  Ten\or Eleven\or Twelve\or Thirteen\or Fourteen\or Fifteen\or Sixteen\or Seventeen\or
  Eighteen\or Nineteen\else\house@tens{#1}\fi}
\newcommand\house@tens[1]{%
  \ifnum#1>99 \number#1\else
  \ifcase\numexpr(#1-5)/10\relax\or\or Twenty\or Thirty\or Forty\or Fifty\or Sixty\or
  Seventy\or Eighty\or Ninety\fi
  \ifnum\numexpr#1-10*((#1-5)/10)\relax>0 -\house@numberword{\numexpr#1-10*((#1-5)/10)\relax}\fi
  \fi}
\newcommand\house@labelline{%
  \ifdefstring{\house@chapterlabel}{none}{}{%
    {\large\scshape\chaptername\ %
     \ifdefstring{\house@chapterlabel}{word}{\house@numberword{\value{chapter}}}{\thechapter}}%
    \par\vskip 10\p@}}
\newcommand\house@chapteralign{%
  \ifdefstring{\house@chapterstyle}{left}{\raggedright}{\centering}}
\newif\ifhouse@plainchapters
\ifdefstring{\house@chapterstyle}{plain}{\house@plainchapterstrue}{}
\ifhouse@plainchapters\else
  \renewcommand\@makechapterhead[1]{%
    \vspace*{0.18\textheight}%
    {\parindent\z@\house@chapteralign\normalfont
     \ifnum\c@secnumdepth>\m@ne\house@labelline\fi
     {\house@headface\LARGE #1\par}\nobreak\vskip 36\p@}}
  \renewcommand\@makeschapterhead[1]{%
    \vspace*{0.18\textheight}%
    {\parindent\z@\house@chapteralign\normalfont
     {\house@headface\LARGE #1\par}\nobreak\vskip 36\p@}}
\fi

% The book's divisions: roman folios and unnumbered chapters before the text, arabic after.
\newcommand\frontmatter{\cleardoublepage\pagenumbering{roman}\setcounter{secnumdepth}{-1}}
\newcommand\mainmatter{\cleardoublepage\pagenumbering{arabic}\setcounter{secnumdepth}{0}}
\newcommand\backmatter{\cleardoublepage\setcounter{secnumdepth}{-1}}

% ── Epigraph, scene break, drop capital, small capitals ─────────────────────
\newcommand\house@noindentnext{\global\let\if@afterindent\iffalse\@afterheading}
\newenvironment{epigraph}{%
  \par\vspace{\baselineskip}%
  \begin{list}{}{\setlength\leftmargin{0.3\linewidth}\setlength\rightmargin{0pt}%
    \setlength\topsep{0pt}\setlength\parsep{0.4\baselineskip}}%
  \item\relax\small\itshape}{%
  \end{list}\par\vspace{1.5\baselineskip}\house@noindentnext}
\newcommand\epigraphsource[1]{\par{\raggedleft\upshape #1\par}}

\newcommand\house@stars{*\quad*\quad*}
\newcommand\house@glyph[1]{\iffontchar\font#1 \symbol{#1}\else\house@stars\fi}
\ifdefstring{\house@scenebreak}{asterism}{\newcommand\house@mark{\house@glyph{"2042}}}{%
\ifdefstring{\house@scenebreak}{fleuron}{\newcommand\house@mark{\house@glyph{"2766}}}{%
\ifdefstring{\house@scenebreak}{rule}{\newcommand\house@mark{\rule[0.5ex]{3em}{0.4pt}}}{%
\ifdefstring{\house@scenebreak}{space}{\newcommand\house@mark{}}{%
  \newcommand\house@mark{\house@stars}}}}}
\newcommand\setscenebreak[1]{\renewcommand\house@mark{#1}}
\newcommand\scenebreak{\par\penalty-100\vspace{\baselineskip}%
  \noindent\makebox[\linewidth]{\house@mark}\par\nopagebreak\vspace{\baselineskip}%
  \house@noindentnext}

\newif\ifhouse@lettrine
\IfFileExists{lettrine.sty}{\RequirePackage{lettrine}\house@lettrinetrue}{}
\newcommand\dropcap[2]{\ifvmode\noindent\fi
  \ifhouse@lettrine\ifhouse@dropcaps\lettrine{#1}{#2}\else#1\textsc{#2}\fi\else#1\textsc{#2}\fi}

\newcommand\smallcaps[1]{\textsc{#1}}

% ── Flags, maps, front and back matter ───────────────────────────────────────
% A character the font cannot draw prints as nothing; a proof logs it as 'Missing character',
% which make print reports, and a final print stops on it (XeTeX 2021 or later).
\ifhouse@final\AtBeginDocument{\tracinglostchars=3\relax}\fi
\RequirePackage{xcolor}
\newcommand\dnote[1]{\ifhouse@final
    \ClassError{housebook}{An open flag in a final print: \detokenize{#1}}%
      {Resolve it in the Markdown, re-typeset the chapter, and print again.}%
  \else
    \ClassWarning{housebook}{Open flag in the proof: \detokenize{#1}}%
    {\color{red}\sffamily\footnotesize[#1]}%
  \fi}
\RequirePackage{graphicx}
\newcommand\housemap[1]{\clearpage\thispagestyle{empty}\vspace*{\fill}%
  \begin{center}\includegraphics[width=\textwidth,height=0.9\textheight,keepaspectratio]{#1}%
  \end{center}\vspace*{\fill}\clearpage}
\newcommand\houseinput[1]{\InputIfFileExists{#1}{}%
  {\ClassWarning{housebook}{#1.tex not found; left out of this print}}}
\NewDocumentCommand\housereferences{O{References}}{%
  \IfFileExists{build/typeset/references.tex}%
    {\chapter{#1}\input{build/typeset/references.tex}}%
    {\ClassWarning{housebook}{No reference list at build/typeset/references.tex; make print writes it
      when the project keeps references}}}
\newcommand\runningtitle[1]{\gdef\house@runningtitle{#1}}
\AtBeginDocument{\ifdefined\house@runningtitle\else\let\house@runningtitle\@title\fi}
\newcommand\subtitle[1]{\gdef\house@subtitle{#1}}
\newcommand\housetitlepage{%
  \begin{titlepage}\centering\vspace*{0.25\textheight}%
  {\house@headface\Huge\@title\par}%
  \ifdefined\house@subtitle\vskip 1em{\house@headface\Large\house@subtitle\par}\fi
  \vskip 3em{\large\scshape\@author\par}\vfill\end{titlepage}\cleardoublepage}

% ── Footnotes, running heads, page breaking ──────────────────────────────────
\ifdefstring{\house@footnotes}{hang}{%
  \renewcommand\@makefntext[1]{\setlength\parindent{1em}\noindent
    \hangindent=1.5em\hangafter=1\makebox[1.5em][l]{\@thefnmark.}#1}}{}
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\fancyhead[LE]{\small\scshape\house@runningtitle}
\fancyhead[RO]{\small\scshape\rightmark}
\fancyfoot[C]{\small\thepage}
\renewcommand\headrulewidth{0pt}
\renewcommand\chaptermark[1]{\markboth{#1}{#1}}
\fancypagestyle{plain}{\fancyhf{}\fancyfoot[C]{\small\thepage}\renewcommand\headrulewidth{0pt}}
\IfFileExists{emptypage.sty}{\RequirePackage{emptypage}}{}
\widowpenalty=10000
\clubpenalty=10000
\interfootnotelinepenalty=10000
\setlength{\emergencystretch}{3em}
\IfFileExists{microtype.sty}{\RequirePackage{microtype}}{}

% ── What Pandoc's LaTeX writer emits, which its own template would define ────
\RequirePackage{longtable,booktabs,array,calc}
\IfFileExists{footnotehyper.sty}{\RequirePackage{footnotehyper}}{\RequirePackage{footnote}}
\makesavenoteenv{longtable}
\RequirePackage{soul}
\providecommand{\tightlist}{\setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}}
\providecommand{\passthrough}[1]{#1}
\providecommand{\pandocbounded}[1]{#1}
\providecommand{\foreignlanguage}[2]{#2}
\ifcsdef{otherlanguage}{}{\newenvironment{otherlanguage}[1]{}{}}
\def\maxwidth{\ifdim\Gin@nat@width>\linewidth\linewidth\else\Gin@nat@width\fi}
\def\maxheight{\ifdim\Gin@nat@height>\textheight\textheight\else\Gin@nat@height\fi}
\setkeys{Gin}{width=\maxwidth,height=\maxheight,keepaspectratio}
\newlength{\cslhangindent}\setlength{\cslhangindent}{1.5em}
\newlength{\csllabelwidth}\setlength{\csllabelwidth}{3em}
\newlength{\cslentryspacingunit}\setlength{\cslentryspacingunit}{\parskip}
\newenvironment{CSLReferences}[2]{%
  \setlength{\parindent}{0pt}%
  \ifodd #1\let\oldpar\par\def\par{\hangindent=\cslhangindent\oldpar}\fi
  \setlength{\parskip}{#2\cslentryspacingunit}}{}
\newcommand{\CSLBlock}[1]{#1\hfill\break}
\newcommand{\CSLLeftMargin}[1]{\parbox[t]{\csllabelwidth}{#1}}
\newcommand{\CSLRightInline}[1]{\parbox[t]{\linewidth - \csllabelwidth}{#1}\break}
\newcommand{\CSLIndent}[1]{\hspace{\cslhangindent}#1}
\RequirePackage[hidelinks]{hyperref}
\AtBeginDocument{\hypersetup{pdftitle={\@title},pdfauthor={\@author}}}

\endinput
