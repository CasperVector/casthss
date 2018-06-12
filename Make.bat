@echo off

@rem Copyright (c) 2008-2009 solvethis
@rem Copyright (c) 2010-2012 Casper Ti. Vector
@rem Public domain.

set JOB=thesis
@rem 目前只支持 xelatex。
set LATEX=latex
set BIBTEX=biber -l zh__pinyin --output-safechars
set DVIPDF=dvipdfmx

if "%LATEX%"=="latex" (set DODVIPDF=%DVIPDF% %JOB%
) else (set DODVIPDF=echo No need to run %DVIPDF%.)
if "%1"=="" goto doc
if "%1"=="doc" goto doc
if "%1"=="clean" (goto clean) else (goto usage)

:doc
%LATEX% %JOB%
%BIBTEX% %JOB%
%LATEX% %JOB%
%LATEX% %JOB%
%DODVIPDF%
goto end

:clean
del *.aux *.bbl *.bcf *.blg *.dvi *.lof *.log *.lot *.run.xml *.toc *.out
del missfont.log chap\*.aux
goto end

:usage
echo %0 [doc] [clean]
goto end

:end
pause

@rem vim:ts=4:sw=4
