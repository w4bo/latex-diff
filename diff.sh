cp -R /.ssh ~/.ssh
chmod 400 ~/.ssh/id_rsa

if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

cd /data

rm -rf old
git clone $REPO old
cd /data/old
git checkout $COMMIT

cd -
rm -rf new
git clone $REPO new

rm -rf diff
mkdir diff
cp -R new/* diff

latexdiff --preamble=/data/preamble.tex --flatten old/main.tex new/main.tex > diff/diff.tex
latexdiff --preamble=/data/preamble.tex old/references.bib new/references.bib > diff/references.bib

latexdiff --flatten old/main.tex new/main.tex > diff/diff-all.tex
latexdiff old/references.bib new/references.bib > diff/references.bib

cd /data/diff

pdflatex -file-line-error -interaction=batchmode diff.tex || true
bibtex diff.aux || true
pdflatex -file-line-error -interaction=batchmode diff.tex || true
pdflatex -file-line-error -interaction=batchmode diff.tex || true

pdflatex -file-line-error -interaction=batchmode diff-all.tex || true
bibtex diff-all.aux || true
pdflatex -file-line-error -interaction=batchmode diff-all.tex || true
pdflatex -file-line-error -interaction=batchmode diff-all.tex || true