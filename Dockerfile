FROM blang/latex
RUN apt install -y latexdiff
COPY diff.sh /data/diff.sh
RUN chmod +x /data/diff.sh