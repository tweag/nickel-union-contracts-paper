{stdenv, fetchurl, unzip, texlive}:

stdenv.mkDerivation rec {
  version = "1.1.1";
  pname = "pbalance";
  # name = "${pname}-${version}";
  tlType = "run";

  src = fetchurl {
    url = "https://gitlab.com/lago/pbalance/-/archive/ctan-2021-05-24/pbalance-ctan-2021-05-24.zip";
    sha256 = "4de405b2163e57009ee8557b31ca6af84984063d735f529dd98f2765fe88b1bc";
  };

  buildInputs = [ unzip texlive ];

  # Multiple files problem
  unpackPhase = ''
    unzip $src
  '';

  buildPhase = '' 
    cd pbalance-ctan-2021-05-24
    latex pbalance.ins
  '';

  installPhase = '' 
    mkdir -p $out/tex/latex/${pname}
    cp -va pbalance-ctan-2021-05-24/*.sty $out/tex/latex/${pname}
  '';
}
