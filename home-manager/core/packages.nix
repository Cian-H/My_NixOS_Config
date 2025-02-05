{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: let
  monaspaceFont = pkgs.callPackage ../../modules/monaspice_font.nix {};
in {
  home.packages =
    (with pkgs; [
      alejandra
      git-extras
      git-credential-manager
      meld
      unzip
    ])
    ++ (with unstablePkgs; [
      devenv
      lazygit
      nixd
    ])
    ++ [
      monaspaceFont
    ];
}
