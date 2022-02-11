cd /data

cp -R .ssh ~/.ssh
chmod 400 ~/.ssh/id_rsa

if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

git clone $REPO /old
cd /old
git checkout $COMMIT

cd -
git clone $REPO /new

rm -rf diff
mkdir diff
cp -R /new/* diff

latexdiff --preamble=/data/preamble.tex --flatten /old/main.tex /new/main.tex > diff/diff.tex
# latexdiff /old/references.bib /new/references.bib > diff/references.bib

rm -rf diff-all
mkdir diff-all
cp -R new/* diff-all

latexdiff --flatten /old/main.tex /new/main.tex > diff-all/diff-all.tex
# latexdiff /old/references.bib /new/references.bib > diff-all/references.bib

cd /data/diff

pdflatex -file-line-error -interaction=batchmode diff.tex || true
bibtex diff.aux || true
pdflatex -file-line-error -interaction=batchmode diff.tex || true
pdflatex -file-line-error -interaction=batchmode diff.tex || true
rm -rf *.aux *.log *.lof *.gz *.toc *.bak~ *.bbl *.out *.blg *.spl

cd /data/diff-all

pdflatex -file-line-error -interaction=batchmode diff-all.tex || true
bibtex diff-all.aux || true
pdflatex -file-line-error -interaction=batchmode diff-all.tex || true
pdflatex -file-line-error -interaction=batchmode diff-all.tex || true
rm -rf *.aux *.log *.lof *.gz *.toc *.bak~ *.bbl *.out *.blg *.spl