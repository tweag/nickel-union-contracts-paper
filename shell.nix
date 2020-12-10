with import (fetchTarball
https://github.com/NixOS/nixpkgs-channels/archive/nixos-20.03.tar.gz) {};

stdenv.mkDerivation {
  name = "docsEnv";
  buildInputs = [ biber
                  pdftk
                  zip
                  (texlive.combine {
                       inherit (texlive)
                       biblatex
                       collection-fontsrecommended
                       comment
                       fontaxes
                       latexmk
                       listings
                       lm
                       scheme-small
                       ucs
                       wasy cm-super unicode-math lm-math capt-of
                       mathpartir
                       appendix;
                  })
                ];
}
