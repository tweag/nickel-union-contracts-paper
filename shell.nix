with import (fetchTarball
https://github.com/nixos/nixpkgs/archive/nixos-20.09.tar.gz) {};

stdenv.mkDerivation {
  name = "docsEnv";
  buildInputs = [ biber
                  pdftk
                  zip
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
                       ;
                  })
                ];
}
