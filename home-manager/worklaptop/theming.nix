{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  gtk = {
    enable = true;
    iconTheme = {
      name = "Tokyonight-Light";
      package = pkgs.tokyonight-gtk-theme;
    };
    theme = {
      name = "Tokyonight-Dark-BL-LB";
      package = pkgs.tokyonight-gtk-theme;
    };
    cursorTheme = {
      name = "phinger-cursors-dark";
      package = pkgs.phinger-cursors;
    };
  };
}
