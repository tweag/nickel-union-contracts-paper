with import (fetchTarball
https://github.com/nixos/nixpkgs/archive/nixos-20.09.tar.gz) {};

stdenv.mkDerivation {
  name = "docsEnv";
  buildInputs = [ biber
                  pdftk
                  zip
                  git-latexdiff
                  (texlive.combine {
                       inherit (texlive)
                       biblatex
                       collection-fontsrecommended
                       # comment
                       fontaxes
                       latexmk
                       listings
                       lm
                       scheme-small
                       ucs
                       wasy cm-super unicode-math lm-math capt-of
                       mathpartir
                       url
                       appendix
                       xargs todonotes
                       # Packages required for the ACM Sigplan article format
                       totpages trimspaces
                       libertine environ hyperxmp
                       ifmtarg comment ncctools
                       inconsolata newtx txfonts
                       xstring atenddvi zref preprint
                       microtype
                       ;
                  })
                ];
  shellHook = ''
    alias revision-diff='git-latexdiff --latexmk dls21.1-no-marks --main paper.tex -o reviews-dls/diff.pdf'
  '';
}
