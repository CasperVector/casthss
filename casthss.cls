% UCAS dissertation document class, based on casthss
%
% Copyright (c) 2008-2009 solvethis
% Copyright (c) 2010-2018 Casper Ti. Vector
%
% This work may be distributed and/or modified under the conditions of the
% LaTeX Project Public License, either version 1.3 of this license or (at
% your option) any later version.
% The latest version of this license is in
%   https://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX version
% 2005/12/01 or later.
%
% This work has the LPPL maintenance status `maintained'.
% The current maintainer of this work is Casper Ti. Vector.
%
% This work consists of the following files:
%   casthss.cls
%   casthss.def

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{casthss}
	[2017/03/01 v1.7.4 UCAS dissertation document class]

% eg. `\thss@int@boolopt{spacing}{true}' will expand to:
%   \newif\ifthss@opt@spacing \thss@opt@spacingtrue
%   \DeclareOption{spacing}{\thss@opt@spacingtrue}
%   \DeclareOption{nospacing}{\thss@opt@spacingfalse}
\def\thss@int@boolopt#1#2{
	\expandafter\newif\csname ifthss@opt@#1\endcsname
	\@nameuse{thss@opt@#1#2}
	\DeclareOption{#1}{\@nameuse{thss@opt@#1true}}
	\DeclareOption{no#1}{\@nameuse{thss@opt@#1false}}
}
% Whether to enable `\Uppercase' (works problematically) in heading marks.
\thss@int@boolopt{uppermark}{false}
% Whether to modify fonts according to school regulation.
\thss@int@boolopt{casfont}{true}
% Whether to modify spacing according to school regulation.
\thss@int@boolopt{casspace}{true}
% Whether to use some common settings for adjusting spacing.
\thss@int@boolopt{spacing}{true}
% Add PDF bookmark for table of contents.
\thss@int@boolopt{pdftoc}{true}
% Whether to automatically set up properties for generated PDF from user
% defined document information (author, title, etc.).
\thss@int@boolopt{pdfprop}{true}
% Pass all other options to `ctexbook' document class.
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexbook}}
% Process all class options now.
\ProcessOptions\relax

% Prevent fontspec (loaded by xeCJK) from interfering with newtxmath.
\ifthss@opt@casfont\PassOptionsToPackage{no-math}{fontspec}\fi
% casthss is based on ctexbook; we use `xiao 4' as default font size.
\LoadClass[UTF8, zihao = -4]{ctexbook}[2014/03/06]
% ctex 2.x no longer loads ifpdf and ifxetex by itself.
\RequirePackage{ifpdf, ifxetex}
% Provides support for `key = val' grammar.
\RequirePackage{keyval}
% Graphics support.
\RequirePackage{graphicx}[1999/02/16]
% Provides utilities for setting up page layout.
\RequirePackage{geometry}
% fancyhdr provides utilities for setting up headers and footers.
\RequirePackage{fancyhdr}
% Provides `\uline' used in `\maketitle' and `\emaketitle'.
\RequirePackage{ulem}
% Provides `\multirow' used in `\emaketitle'.
\RequirePackage{multirow}
% `\AtEndOfClass' used to avoid `PDF destination not defined' with setspace.
\AtEndOfClass{\RequirePackage{hyperref}}
\input{casthss.def}

\ifthss@opt@casfont
	% Use Times New Roman / Arial according to school regulation.
	% Option used to prevent newtxtext from manipulating footnote marks.
	\RequirePackage[defaultsups]{newtxtext}
	\RequirePackage[cmintegrals, varg]{newtxmath}
\fi

\ifthss@opt@casspace
	\linespread{1.52}\selectfont
	% Provides utilities for setting TOC format; `titles' applied to avoid
	% interfering with LaTeX's own title mechanism.
	\RequirePackage[titles]{tocloft}
	\setlength{\cftbeforechapskip}{6bp plus 1bp}
	\setlength{\cftsecindent}{\ccwd}
	\setlength{\cftsubsecindent}{2\ccwd}
	\setlength{\cftsubsubsecindent}{4\ccwd}
	\renewcommand{\cftsecfont}{\bfseries}
	\renewcommand{\cftsubsecfont}{\bfseries}
	\renewcommand{\cftsubsubsecfont}{\bfseries}
	% `caption' modifies font size and separator of captions.  `subcaption'
	% provides functions similar to `subfigure'/`subfig' but does not clash with
	% `tocloft'; it clashes with `subfigure'/`subfig', but the error message will
	% say they cannot be used simultaneously.
	\RequirePackage{caption, subcaption}
	\DeclareCaptionFont{bfive}{\zihao{5}\bfseries}
	\DeclareCaptionLabelSeparator{quad}{\quad}
	\captionsetup{font = bfive, labelsep = quad}
\fi

\ifthss@opt@spacing
	% Provides utility to modify footnote spacing.
	% Option used to make sure it does not render interleaf pages totally blank.
	\RequirePackage[cleardoublepage = current]{scrextend}
	% Set up footnote spacing: paragraph indent 2 ccwd, 0.5 ccwd after mark.
	\deffootnote[2\ccwd]{0pt}{2\ccwd}%
		{\textsuperscript{\thefootnotemark}\hspace{0.5\ccwd}}
	% Make spacing nicer in some situations (eg. footnotes and verbatims).
	\RequirePackage{setspace}
	% Remove superfluous spacing between footnotes.
	\setlength{\footnotesep}{0pt}
	% Lists often appear to be too sparse when items are just one or two lines
	% long. Here we cancel the extra vertical spacing between list items.
	% The list margin is adjusted due to Chinese typesetting traditions.
	\RequirePackage{enumitem}
	\setlist{nolistsep, leftmargin = 1.5\parindent}
\fi

\AtBeginDocument{
	% Set up spacing for displayed formulae.
	\setlength{\abovedisplayskip}{\belowdisplayshortskip}
	\setlength{\belowdisplayskip}{\abovedisplayskip}

	\ifthss@opt@pdftoc
		% Add PDF bookmark for table of contents.
		\let\thss@tmp@tableofcontents\tableofcontents
		\renewcommand{\tableofcontents}{%
			\thss@int@pdfmark{\contentsname}{contents}
			\thss@tmp@tableofcontents%
		}
	\fi

	\ifthss@opt@pdfprop
		% Automatically generate properties for generated PDF.
		% Use English properties to avoid problems with character encodings.
		\newcommand*{\setpdfproperties}{%
			\hypersetup{
				pdfauthor = {\@eauthor}, pdftitle = {\@etitle},
				pdfsubject = {UCAS \ethesisname}, pdfkeywords = {\@ekeywords}
			}%
		}
		% Set up the properties when generating the title page because the document
		% information should have been all defined before this.
		\let\thss@tmp@maketitle\maketitle
		% NOTE: `\hypersetup' must appear before `\maketitle', otherwise it might
		% not act as expected.
		\renewcommand\maketitle{\setpdfproperties\thss@tmp@maketitle}
	\fi
}

% eg. `\thss@int@infoitema{ctitle}' will expand to:
%   \def\ctitle#1{\def\@ctitle{#1}}
%   \define@key{thss@info}{ctitle}{\ctitle{#1}}
\def\thss@int@infoitema#1{
	\@namedef{#1}##1{\@namedef{@#1}{##1}}
	\define@key{thss@info}{#1}{\@nameuse{#1}{##1}}
}
% eg. `\thss@int@infoitemb{cthesisname}' will expand to:
%   \define@key{thss@info}{cthesisname}{\def\cthesisname{#1}}
\def\thss@int@infoitemb#1{
	\define@key{thss@info}{#1}{\@namedef{#1}{##1}}
}
% Set up document information entries.
\thss@int@infoitema{ctitle}
\thss@int@infoitema{etitle}
\thss@int@infoitema{cauthor}
\thss@int@infoitema{eauthor}
\thss@int@infoitema{cdate}
\thss@int@infoitema{edate}
\thss@int@infoitema{cmentor}
\thss@int@infoitema{ementor}
\thss@int@infoitema{cdegree}
\thss@int@infoitema{edegree}
\thss@int@infoitema{cmajor}
\thss@int@infoitema{emajor}
\thss@int@infoitema{cschool}
\thss@int@infoitema{eschool}
\thss@int@infoitema{mentorlines}
\thss@int@infoitema{confidential}
\thss@int@infoitema{ckeywords}
\thss@int@infoitema{ekeywords}
\thss@int@infoitemb{cthesisname}
\thss@int@infoitemb{ethesisname}
\thss@int@infoitemb{cabstractname}
\thss@int@infoitemb{eabstractname}
% Set up document information using the `key = value' grammar.
\newcommand*{\casthssinfo}[1]{\setkeys{thss@info}{#1}}

% Set up page layout.
\geometry{
	a4paper, hmargin = 3.17cm, top = 2.54cm, bottom = 2.65cm,
	headheight = 0.4cm, headsep = 0.64cm, footskip = 1.12cm
}

% Set up chapter/section/... captions.
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{2}
\ctexset{
	chapter = {
		beforeskip = {0bp}, afterskip = {18bp plus 0.2ex},
		number = {\arabic{chapter}}, nameformat = {}, titleformat = {},
		format = {\zihao{4}\bfseries\heiti\centering}
	}, section = {
		beforeskip = {24bp plus 1ex minus 0.2ex},
		afterskip = {6bp plus 0.2ex}, format = {\bfseries\heiti}
	}, subsection = {
		beforeskip = {12bp plus 1ex minus 0.2ex},
		afterskip = {6bp plus 0.2ex}, format = {\bfseries\heiti}
	}, subsubsection = {
		beforeskip = {12bp plus 1ex minus 0.2ex},
		afterskip = {6bp plus 0.2ex}, format = {\bfseries\heiti}
	}
}

% `\MakeUppercase' works problematically.
% eg. it converts `\cite{ctex}' into `\cite{CTEX}'.
% This option can disable `\MakeUppercase' in left/right heading marks.
\ifthss@opt@uppermark
	\def\thss@int@setcase#1{#1}
\else
	% Code copied from fancyhdr's `\nouppercase', with the redefinition of
	% `\uppercase' dropped to avoid disrupting CJKutf8.
	% cf. <https://code.google.com/p/ctex-kit/issues/detail?id=147>.
	\def\thss@int@setcase#1{%
		\let\MakeUppercase\relax%
		\expandafter\let\csname MakeUppercase \endcsname\relax%
		#1%
	}
\fi
% The actual fage style setup.
\fancypagestyle{plain}{
	\fancyhf{}
	\fancyhead[CE]{\zihao{-5}\normalfont{\@ctitle}}
	\fancyhead[CO]{\zihao{-5}\normalfont\thss@int@setcase{\leftmark}}
}
\pagestyle{plain}

% This places a bookmark pointing to somewhere near the page header;
% Result of simple `\chapter{...} \pdfbookmark{...}' does not look nice,
% because the bookmark will point to somewhere below the chapter mark.
\def\thss@int@pdfmark#1#2{%
	\if@openright\cleardoublepage\else\clearpage\fi
	\pdfbookmark[0]{#1}{#2}%
}

% Usage: \thss@int@fillinblank{(number of lines)}{(line width)}{(contents)}
\def\thss@int@fillinblank#1#2#3{%
	\makebox[0pt][l]{\parbox[t]{#2}{\centering{#3}}}\mbox{}%
	\parbox[t]{#2}{%
		\newcount\thss@tmp@linecount
		\thss@tmp@linecount=#1
		\loop\ifnum\thss@tmp@linecount>0
			% Fill specified space with underline on the bottom line. `\underline'
			% draws line on the baseline (not the bottom line), and this is why
			% `\uline' is used here instead.
			\ifnum\thss@tmp@linecount=1
				\uline{\makebox[#2]{}}
			\else
				\uline{\makebox[#2]{}}\\
			\fi
		\advance\thss@tmp@linecount by -1\relax
		\repeat%
	}%
}

% Set up format of the title page (cover).
\renewcommand{\maketitle}{%
	\thss@int@pdfmark{\ctitlepagename}{ctitlepage}
	% Make the title page centered.
	\begin{titlepage}\begin{center}
		% Confidential level (if any).
		\unless\ifx\@confidential\empty{%
			\raggedleft\heiti\bfseries\zihao{3}{\label@confidential}%
			\uline{\@confidential}\vspace{\stretch{0.5}}\par%
		}\fi%
		% Emblem and inscription of the university, and type of thesis.
		{%
			\heiti\bfseries\zihao{1}%
			\includegraphics[height = 2.4em]{caslogo}\hspace{0.35em}%
			\raisebox{0.125em}{\includegraphics[height = 2.15em]{ucasword}}\\[0.9em]
			{\cthesisname}%
		}
		\vfill
		% Title of the thesis.
		{%
			\heiti\bfseries\zihao{3}\linespread{1.75}\selectfont
			\thss@int@fillinblank{2}{0.84\textwidth}{{\@ctitle}}%
		}
		\vfill
		% Information about the author.
		{%
			\songti\bfseries\zihao{4}\linespread{1.9}\selectfont
			\def\thss@tmp@len{0.75\textwidth}
			\begin{tabular}{l@{\extracolsep{0.2em}}c}
				{\label@cauthor}	&
				\thss@int@fillinblank{1}{\thss@tmp@len}{\@cauthor}	\\
				{\label@cmentor}	&
				\thss@int@fillinblank{\@mentorlines}%
					{\thss@tmp@len}{\@cmentor}	\\\\[-1.75em]
				{\label@cdegree}	&
				\thss@int@fillinblank{1}{\thss@tmp@len}{\@cdegree}	\\
				{\label@cmajor}		&
				\thss@int@fillinblank{1}{\thss@tmp@len}{\@cmajor}		\\
				{\label@cschool}	&
				\thss@int@fillinblank{1}{\thss@tmp@len}{\@cschool}	\\
			\end{tabular}%
		}
		\vfill
		% Date.
		{\songti\bfseries\zihao{4}\@cdate}
	\end{center}\end{titlepage}%
}

\newcommand{\emaketitle}{%
	\thss@int@pdfmark{Title page}{etitlepage}
	\begin{center}
		\bfseries\zihao{4}\linespread{1.9}\selectfont
		{\zihao{3}\uline{\@etitle}}
		\vfill
		{%
			A {\ethesisname} submitted to\\
			University of Chinese Academy of Sciences\\
			in partial fulfillment of the requirement\\
			for the degree of\\
			{\@edegree}\\
			in {\@emajor}\\
			by\\
			{\@eauthor}
		}
		\vfill
		\begin{tabular}[t]{l}Supervisor:\\\end{tabular}\hspace{-0.5em}%
		\begin{tabular}[t]{l}\@ementor\\\end{tabular}
		\vfill
		{\@eschool}\\{\@edate}
	\end{center}%
}

% Typeset the Chinese abstract.
\newenvironment{cabstract}{%
	\thss@int@pdfmark{\cabstractname}{cabstract}
	\chapter*{\cabstractname}\markboth{\cabstractname}{}%
}{%
	\par\vspace{\baselineskip}
	\noindent\textbf{\label@ckeywords}{\@ckeywords}%
}

% Typeset the English abstract.
\newenvironment{eabstract}{%
	\thss@int@pdfmark{Abstract}{eabstract}
	\chapter*{Abstract}\markboth{Abstract}{}%
}{%
	\par\vspace{\baselineskip}
	\noindent\textbf{Keywords:\ }{\@ekeywords}%
}

\endinput
% vim:ft=tex:ts=2:sw=2
