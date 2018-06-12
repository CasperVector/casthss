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
	[2017/03/01 v1.7.4 Peking University dissertation document class]

% eg. `\casthss@int@boolopt{spacing}{true}' will expand to:
%   \newif\ifcasthss@opt@spacing \casthss@opt@spacingtrue
%   \DeclareOption{spacing}{\casthss@opt@spacingtrue}
%   \DeclareOption{nospacing}{\casthss@opt@spacingfalse}
\def\casthss@int@boolopt#1#2{
	\expandafter\newif\csname ifcasthss@opt@#1\endcsname
	\@nameuse{casthss@opt@#1#2}
	\DeclareOption{#1}{\@nameuse{casthss@opt@#1true}}
	\DeclareOption{no#1}{\@nameuse{casthss@opt@#1false}}
}
% Whether to enable `\Uppercase' (works problematically) in heading marks.
\casthss@int@boolopt{uppermark}{false}
% Whether to modify fonts according to school regulation.
\casthss@int@boolopt{casfont}{true}
% Whether to modify spacing according to school regulation.
\casthss@int@boolopt{casspace}{true}
% Whether to use some common settings for adjusting spacing.
\casthss@int@boolopt{spacing}{true}
% Add PDF bookmark for table of contents.
\casthss@int@boolopt{pdftoc}{true}
% Whether to automatically set up properties for generated PDF from user
% defined document information (author, title, etc.).
\casthss@int@boolopt{pdfprop}{true}
% Pass all other options to `ctexbook' document class.
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexbook}}
% Process all class options now.
\ProcessOptions\relax

% Prevent fontspec (loaded by xeCJK) from interfering with newtxmath.
\ifcasthss@opt@casfont\PassOptionsToPackage{no-math}{fontspec}\fi
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
% Provides `\uline' used in `\maketitle'.
\RequirePackage{ulem}
% Provides `\multirow' used in `\emaketitle'.
\RequirePackage{multirow}
% `\AtEndOfClass' used to avoid `PDF destination not defined' with setspace.
\AtEndOfClass{\RequirePackage{hyperref}}
\input{casthss.def}

\ifcasthss@opt@casfont
	% Use Times New Roman / Arial according to school regulation.
	% Option used to prevent newtxtext from manipulating footnote marks.
	\RequirePackage[defaultsups]{newtxtext}
	\RequirePackage[cmintegrals, varg]{newtxmath}
\fi

\ifcasthss@opt@casspace
	% lineskip / baselineskip = 20 bp / (12 bp * (6 / 5)).
	\linespread{1.39}\selectfont
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

\ifcasthss@opt@spacing
	% Provides utility to modify footnote spacing.
	% Option used to make sure it does not render interleaf pages totally blank.
	\RequirePackage[cleardoublepage = current]{scrextend}
	% Set up footnote spacing: symbol indent 1 ccwd, paragraph indent 2 ccwd,
	% 0.5 ccwd between symbol and paragraph.
	\deffootnote{\ccwd}{2\ccwd}{\thefootnotemark\hspace{0.5\ccwd}}
	% Make spacing nicer in some situations (eg. footnotes and verbatims).
	\RequirePackage{setspace}
	% Lists often appear to be too sparse when items are just one or two lines
	% long. Here we cancel the extra vertical spacing between list items.
	\RequirePackage{enumitem}
	\setlist{nolistsep}
\fi

\AtBeginDocument{
	\ifcasthss@opt@pdftoc
		% Add PDF bookmark for table of contents.
		\let\casthss@tmp@tableofcontents\tableofcontents
		\renewcommand{\tableofcontents}{%
			\casthss@int@pdfmark{\contentsname}{contents}
			\casthss@tmp@tableofcontents%
		}
	\fi

	\ifcasthss@opt@pdfprop
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
		\let\casthss@tmp@maketitle\maketitle
		% NOTE: `\hypersetup' must appear before `\maketitle', otherwise it might not
		% act as expected.
		\renewcommand\maketitle{\setpdfproperties\casthss@tmp@maketitle}
	\fi
}

% eg. `\casthss@int@infoitema{ctitle}' will expand to:
%   \def\ctitle#1{\def\@ctitle{#1}}
%   \define@key{casthss@info}{ctitle}{\ctitle{#1}}
\def\casthss@int@infoitema#1{
	\@namedef{#1}##1{\@namedef{@#1}{##1}}
	\define@key{casthss@info}{#1}{\@nameuse{#1}{##1}}
}
% eg. `\casthss@int@infoitemb{cthesisname}' will expand to:
%   \define@key{casthss@info}{cthesisname}{\def\cthesisname{#1}}
\def\casthss@int@infoitemb#1{
	\define@key{casthss@info}{#1}{\@namedef{#1}{##1}}
}
% Set up document information entries.
\casthss@int@infoitema{ctitle}
\casthss@int@infoitema{etitle}
\casthss@int@infoitema{cauthor}
\casthss@int@infoitema{eauthor}
\casthss@int@infoitema{cdate}
\casthss@int@infoitema{edate}
\casthss@int@infoitema{cmentor}
\casthss@int@infoitema{ementor}
\casthss@int@infoitema{cdegree}
\casthss@int@infoitema{edegree}
\casthss@int@infoitema{cmajor}
\casthss@int@infoitema{emajor}
\casthss@int@infoitema{cschool}
\casthss@int@infoitema{eschool}
\casthss@int@infoitema{mentorlines}
\casthss@int@infoitema{confidential}
\casthss@int@infoitema{ckeywords}
\casthss@int@infoitema{ekeywords}
\casthss@int@infoitemb{cthesisname}
\casthss@int@infoitemb{ethesisname}
\casthss@int@infoitemb{cabstractname}
\casthss@int@infoitemb{eabstractname}
% Set up document information using the `key = value' grammar.
\newcommand*{\casthssinfo}[1]{\setkeys{casthss@info}{#1}}

% Set up page layout.
\geometry{
	a4paper, hmargin = 3.17cm, vmargin = 2.54cm,
	headheight = 0.8cm, headsep = 0.24cm, footskip = 1.04cm
}

% Set up spacing for displayed formulae.
\setlength{\abovedisplayskip}{6bp plus 1.5bp minus 3.5bp}
\setlength{\abovedisplayshortskip}{3bp plus 0.75bp minus 1.75bp}
\setlength{\belowdisplayshortskip}{3bp plus 0.75bp minus 1.75bp}
\setlength{\belowdisplayskip}{6bp plus 1.5bp minus 3.5bp}

% Set up chapter/section/... captions.
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{2}
\ctexset{
	chapter = {
		beforeskip = {0bp}, afterskip = {18bp},
		number = \arabic{chapter}, nameformat = {}, titleformat = {},
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
\ifcasthss@opt@uppermark
	\def\casthss@int@setcase#1{#1}
\else
	% Code copied from fancyhdr's `\nouppercase', with the redefinition of
	% `\uppercase' dropped to avoid disrupting CJKutf8.
	% cf. <https://code.google.com/p/ctex-kit/issues/detail?id=147>.
	\def\casthss@int@setcase#1{%
		\let\MakeUppercase\relax%
		\expandafter\let\csname MakeUppercase \endcsname\relax%
		#1%
	}
\fi
% The actual fage style setup.
\fancypagestyle{plain}{
	\fancyhf{}\renewcommand*{\headrulewidth}{0.5bp}
	\fancyhead[CE]{\zihao{-5}\normalfont{\@ctitle}}
	\fancyhead[CO]{\zihao{-5}\normalfont\casthss@int@setcase{\leftmark}}
}
\pagestyle{plain}

% This places a bookmark pointing to somewhere near the page header;
% Result of simple `\chapter{...} \pdfbookmark{...}' does not look nice,
% because the bookmark will point to somewhere below the chapter mark.
\def\casthss@int@pdfmark#1#2{%
	\if@openright\cleardoublepage\else\clearpage\fi
	\pdfbookmark[0]{#1}{#2}%
}

% Usage: \casthss@int@fillinblank{(number of lines)}{(line width)}{(contents)}
\def\casthss@int@fillinblank#1#2#3{%
	\makebox[0pt][l]{\parbox[t]{#2}{\centering{#3}}}\mbox{}%
	\parbox[t]{#2}{%
		\newcount\casthss@tmp@linecount
		\casthss@tmp@linecount=#1
		\loop\ifnum\casthss@tmp@linecount>0
			% Fill specified space with underline on the bottom line. `\underline'
			% draws line on the baseline (not the bottom line), and this is why
			% `\uline' is used here instead.
			\ifnum\casthss@tmp@linecount=1
				\uline{\makebox[#2]{}}
			\else
				\uline{\makebox[#2]{}}\\
			\fi
		\advance\casthss@tmp@linecount by -1\relax
		\repeat%
	}%
}

% Set up format of the title page (cover).
\renewcommand{\maketitle}{%
	\casthss@int@pdfmark{\ctitlepagename}{ctitlepage}
	\begin{titlepage}
		% It will be nicer to use this line skip level in the title page.
		\linespread{1.6}\selectfont
		% Make the title page centered.
		\begin{center}
			% Confidential level (if any).
			\unless\ifx\@confidential\empty{%
				\raggedleft\heiti\bfseries\zihao{3}{\label@confidential}%
				\uline{\@confidential}\vspace{\stretch{0.5}}\par%
			}\fi%
			% Emblem and inscription of the university, and type of thesis.
			{%
				\heiti\bfseries\zihao{1}%
				\includegraphics[height = 2.4em]{caslogo}\hspace{0.35em}%
				\raisebox{0.125em}{\includegraphics[height = 2.15em]{ucasword}}\\[0.8em]
				{\cthesisname}%
			}
			\vfill
			% Title of the thesis.
			{%
				\heiti\bfseries\zihao{3}\casthss@int@fillinblank%
					{2}{0.84\textwidth}{{\@ctitle}}%
			}
			\vfill
			% Information about the author.
			{%
				% Slightly adjust the line skip when using new font size.
				\songti\bfseries\zihao{4}\linespread{1.75}\selectfont
				\def\casthss@tmp@len{0.75\textwidth}
				\begin{tabular}{l@{\extracolsep{0.2em}}c}
					{\label@cauthor}	&
					\casthss@int@fillinblank{1}{\casthss@tmp@len}{\@cauthor}	\\
					{\label@cmentor}	&
					\casthss@int@fillinblank{\@mentorlines}%
						{\casthss@tmp@len}{\@cmentor}	\\\\[-1.75em]
					{\label@cdegree}	&
					\casthss@int@fillinblank{1}{\casthss@tmp@len}{\@cdegree}	\\
					{\label@cmajor}		&
					\casthss@int@fillinblank{1}{\casthss@tmp@len}{\@cmajor}		\\
					{\label@cschool}	&
					\casthss@int@fillinblank{1}{\casthss@tmp@len}{\@cschool}	\\
				\end{tabular}%
			}
			\vfill
			% Date.
			{\songti\bfseries\zihao{4}\@cdate}
		\end{center}
	\end{titlepage}%
}

\newcommand{\emaketitle}{%
	\casthss@int@pdfmark{Title page}{etitlepage}
	\begin{center}
		\bfseries\zihao{4}
		{\zihao{3}\underline{\@etitle}}
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
	\casthss@int@pdfmark{\cabstractname}{cabstract}
	\chapter*{\cabstractname}\markboth{\cabstractname}{}%
}{%
	\par\mbox{}\par
	\noindent\textbf{\label@ckeywords}{\@ckeywords}%
}

% Typeset the English abstract.
\newenvironment{eabstract}{%
	\casthss@int@pdfmark{Abstract}{eabstract}
	\chapter*{Abstract}\markboth{Abstract}{}%
}{%
	\par\mbox{}\par
	\noindent\textbf{Keywords:\ }{\@ekeywords}%
}

\endinput
% vim:ft=tex:ts=2:sw=2
