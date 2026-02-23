{pkgs}: {
  python = pkgs.callPackage ./python.nix {};
  rbw-autofill = pkgs.callPackage ./rbw_autofill.nix {};
  vivaldi-wayland = pkgs.callPackage ./vivaldi_wayland.nix {};
  walker-obsidian-search = pkgs.callPackage ./walker_obsidian_search.nix {};
}
