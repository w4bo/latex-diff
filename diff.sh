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
git clone $REPO /old
cd /old
git checkout $COMMIT
sh /data/compile.sh main
cp main.pdf /data/generated/main-$COMMIT.pdf
# cp main.lacheck.txt /data/generated/main-$COMMIT.lacheck.txt

cd -
rm -rf /new
git clone $REPO /new
cd /new
sh /data/compile.sh main
cp main.lacheck.txt /data/generated/main.lacheck.txt

rm -rf /diff
mkdir /diff
cp -R /new/* /diff

latexdiff --preamble=/data/preamble.tex --flatten /old/main.tex /new/main.tex > /diff/diff.tex
# latexdiff /old/references.bib /new/references.bib > /diff/references.bib

rm -rf /diff-all
mkdir /diff-all
cp -R /new/* /diff-all

latexdiff --flatten /old/main.tex /new/main.tex > /diff-all/diff-all.tex
# latexdiff /old/references.bib /new/references.bib > /diff-all/references.bib

cd /diff
echo "\n\n\n"
ls -las
sh /data/compile.sh diff
cp diff.pdf /data/generated/diff-$COMMIT.pdf
# cp diff.lacheck.txt /data/generated/diff-$COMMIT.lacheck.txt

cd /diff-all
echo "\n\n\n"
ls -las
sh /data/compile.sh diff-all
cp diff-all.pdf /data/generated/diff-all-$COMMIT.pdf