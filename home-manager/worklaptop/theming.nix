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
      name = theme.gtkTheme.name;
      package = theme.gtkTheme.package;
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

  # QT theming
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=${theme.qtTheme.name}
  '';

  # dconf theming settings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = theme.gtkTheme.name;
      icon-theme = theme.iconTheme.name;
      cursor-theme = theme.cursorTheme.name;
    };
  };

  # Ensure theming packages are installed
  home.packages = [
    theme.gtkTheme.package
    theme.qtTheme.package
    theme.iconTheme.package
    theme.cursorTheme.package
  ];
}
