{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  name = "monaspice";
  src = pkgs.fetchurl {
    url = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Monaspace.tar.xz";
    sha256 = "sha256-5dLoGA1d8f5HO1mO2sX2fOOLHZBiSJNus4bdMyozg0Y=";
  };

  unpackPhase = "tar -xJf $src";

  installPhase = ''
    mkdir -p $out/share/fonts
    cp -r * $out/share/fonts
  '';

  meta = {
    description = "The Monaspace type system is a monospaced type superfamily with some modern tricks up its sleeve.";
    homepage = "https://monaspace.githubnext.com";
    license = pkgs.lib.licenses.ofl;
  };
}
