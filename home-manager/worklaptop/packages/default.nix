{pkgs ? import <nixpkgs> {}}: {
  python-env = pkgs.callPackage ./pkgs/python-env/default.nix {};
  rbw-autofill = pkgs.callPackage ./pkgs/rbw-autofill/default.nix {};
  vivaldi-wayland = pkgs.callPackage ./pkgs/vivaldi-wayland/default.nix {};
  walker-obsidian-search = pkgs.callPackage ./pkgs/walker-obsidian-search/default.nix {};
}
