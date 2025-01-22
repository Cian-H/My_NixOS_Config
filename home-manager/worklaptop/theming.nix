{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  # GTK theming
  gtk = {
    enable = true;
    iconTheme = {
      name = "Tokyonight-Light";
      package = pkgs.tokyonight-gtk-theme;
    };
    theme = {
      name = "Tokyonight-Dark";
      package = pkgs.tokyonight-gtk-theme;
    };
    cursorTheme = {
      name = "phinger-cursors-dark";
      package = pkgs.phinger-cursors;
    };
    gtk2.extraConfig = ''
      gtk-theme-name="Tokyonight-Dark"
      gtk-icon-theme-name="Tokyonight-Light"
      gtk-cursor-theme-name="phinger-cursors-dark"
    '';
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
  # dconf theming settings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Tokyonight-Dark";
      icon-theme = "Tokyonight-Light";
      cursor-theme = "phinger-cursors-dark";
    };
  };
}
