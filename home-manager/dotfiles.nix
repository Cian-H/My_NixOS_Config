{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: let
  monaspaceFont = pkgs.callPackage ../modules/monaspice_font.nix {};
in {
  home.file = {
    ".bashrc".source = ./dotfiles/dot_bashrc;
    "monaspice" = {
      source = "${monaspaceFont}/share/fonts/";
      target = ".local/share/fonts/";
      recursive = true;
    };
    "nushell" = {
      source = ./dotfiles/dot_config/nushell;
      target = ".config/nushell";
      recursive = true;
    };
    "nvim" = {
      source = ./dotfiles/dot_config/nvim;
      target = ".config/nvim";
      recursive = true;
    };
    "pypoetry" = {
      source = ./dotfiles/dot_config/pypoetry;
      target = ".config/pypoetry";
      recursive = true;
    };
    "Thunar" = {
      source = ./dotfiles/dot_config/Thunar;
      target = ".config/Thunar";
    };
    "rye" = {
      source = ./dotfiles/dot_config/.rye;
      target = ".config/.rye";
      recursive = true;
    };
  };
}
