{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  theme,
  ...
}: {
  # GTK theming
  gtk = {
    enable = true;
    iconTheme = {
      name = theme.iconTheme.name;
      package = theme.iconTheme.package;
    };
    theme = {
      name = theme.theme.name;
      package = theme.theme.package;
    };
    cursorTheme = {
      name = theme.cursorTheme.name;
      package = theme.cursorTheme.package;
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
      gtk-theme = theme.theme.name;
      icon-theme = theme.iconTheme.name;
      cursor-theme = theme.cursorTheme.name;
    };
  };
}
