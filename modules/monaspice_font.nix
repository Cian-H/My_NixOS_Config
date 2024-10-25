{
  stdenv,
  pkgs,
}:
stdenv.mkDerivation {
  name = "monaspace-nerd-font";
  src = pkgs.fetchurl {
    url = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Monaspace.tar.xz";
    sha256 = "sha256-5dLoGA1d8f5HO1mO2sX2fOOLHZBiSJNus4bdMyozg0Y=";
  };

  unpackPhase = ''
    mkdir -p $out/share/fonts/
    chmod +rw $out/share/fonts/
    tar -xf $src -C $out/share/fonts/
  '';

  installPhase = ''
    find $out/share/fonts -name '*.ttf' -exec mv {} $out/share/fonts/truetype \;
    find $out/share/fonts -name '*.otf' -exec mv {} $out/share/fonts/opentype \;
  '';
}
