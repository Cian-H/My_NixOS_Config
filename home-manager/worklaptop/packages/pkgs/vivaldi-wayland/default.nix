{pkgs}:
pkgs.symlinkJoin {
  name = "vivaldi-wayland";
  paths = [pkgs.vivaldi];
  buildInputs = [pkgs.makeWrapper];
  postBuild = ''
    wrapProgram $out/bin/vivaldi \
      --set NIXOS_OZONE_WL 1 \
      --add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform --ozone-platform-hint=auto"
  '';
}
