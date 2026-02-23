{
  lib,
  stdenv,
  babashka,
  ripgrep,
  walker,
  xdg-utils,
}:
stdenv.mkDerivation {
  pname = "walker-obsidian-search";
  version = "0.1.0";
  src = ./.;
  buildInputs = [babashka ripgrep walker xdg-utils];
  installPhase = ''
    mkdir -p $out/bin
    cp script.clj $out/bin/walker-obsidian-search
    substituteInPlace $out/bin/walker-obsidian-search \
      --replace '"rg"' '"${ripgrep}/bin/rg"' \
      --replace '"walker' '"${walker}/bin/walker' \
      --replace '"xdg-open"' '"${xdg-utils}/bin/xdg-open"'
    chmod +x $out/bin/walker-obsidian-search
  '';
}
