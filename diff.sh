#!/bin/bash
set -xo
cd /data

chmod +x *.sh

cp -R .ssh ~/.ssh
chmod 400 ~/.ssh/id_rsa

rm -rf generated
mkdir generated

if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

rm -rf /old
git clone $REPO_OLD /old
cd /old
git checkout $COMMIT_OLD
sh /data/compile.sh $MAINFILE_OLD
cp $MAINFILE_OLD.pdf /data/generated/$MAINFILE_OLD-$COMMIT_OLD.pdf

cd -
rm -rf /new
git clone $REPO /new
cd /new
sh /data/compile.sh $MAINFILE
cp $MAINFILE.lacheck.txt /data/generated/$MAINFILE.lacheck.txt
cp $MAINFILE.pdf /data/generated/

rm -rf /diff
mkdir /diff
cp -R /new/* /diff

latexdiff --preamble=/data/preamble.tex --flatten /old/$MAINFILE_OLD.tex /new/$MAINFILE.tex > /diff/diff.tex
# latexdiff /old/references.bib /new/references.bib > /diff/references.bib

rm -rf /diff-all
mkdir /diff-all
cp -R /new/* /diff-all

latexdiff --flatten /old/$MAINFILE_OLD.tex /new/$MAINFILE.tex > /diff-all/diff-all.tex
# latexdiff /old/references.bib /new/references.bib > /diff-all/references.bib

cd /diff
echo "\n\n\n"
ls -las
sed -i -e 's/\href//g' diff.tex
sh /data/compile.sh diff
cp diff.log /data/generated/diff.log
cp diff.pdf /data/generated/diff-$COMMIT_OLD.pdf
cp diff.lacheck.txt /data/generated/diff.lacheck.txt
mkdir /data/generated/diff
cp * /data/generated/diff

cd /diff-all
echo "\n\n\n"
ls -las
sed -i -e 's/\href//g' diff.tex
sh /data/compile.sh diff-all
cp diff-all.pdf /data/generated/diff-all-$COMMIT_OLD.pdf