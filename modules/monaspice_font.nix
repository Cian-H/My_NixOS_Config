{
  stdenv,
  pkgs,
}:
stdenv.mkDerivation {
  name = "monaspace-nerd-font";
  src = pkgs.fetchurl {
    url = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Monaspace.tar.xz";
    sha256 = "sha256-+uuQeCeioHrmTI+hpcpIzZ5gyQhKJMSNd5owz2vQaTo=";
  };

  unpackPhase = ''
    mkdir -p $out/share/fonts/
    chmod +rw $out/share/fonts/
    tar -xf $src -C $out/share/fonts/
  '';

  installPhase = ''
    find $out/share/fonts -name '*.ttf' -exec mv {} $out/share/fonts/truetype/ \;
    find $out/share/fonts -name '*.otf' -exec mv {} $out/share/fonts/opentype/ \;
  '';
}
