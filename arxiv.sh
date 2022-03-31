#!/bin/sh

latexmk paper \
&& cp paper.bib paper.bbl paper.tex arxiv/ \
&& rm -f arxiv.zip \
&& zip -r arxiv arxiv
