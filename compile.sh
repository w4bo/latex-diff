#!/bin/bash
lacheck $1.tex >> $1.lacheck.txt
pdflatex -file-line-error -interaction=batchmode $1.tex || true
bibtex $1.aux || true
pdflatex -file-line-error -interaction=batchmode $1.tex || true
pdflatex -file-line-error -interaction=batchmode $1.tex || true
rm -rf *.aux *.log *.lof *.gz *.toc *.bak~ *.bbl *.out *.blg *.spl