{pkgs}: {
  python = pkgs.callPackage ./python.nix {};
  vivaldi-wayland = pkgs.callPackage ./vivaldi_wayland.nix {};
  rbw-autofill = pkgs.callPackage ./rbw_autofill.nix {};
}
