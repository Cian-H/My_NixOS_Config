{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  # GTK theming
  environment.sessionVariables.GTK_THEME = "Tokyonight-Dark";

  # Delegate QT theming to kvantum
  environment.sessionVariables.QT_STYLE_OVERRIDE = "kvantum";

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    fontconfig = {
      defaultFonts = {
        serif = ["NotoSerifNerdFont"];
        sansSerif = ["NotoSansNerdFont"];
        monospace = ["MonaspiceArNerdFontMono"];
      };
    };

    packages = [
      pkgs.corefonts
      pkgs.liberation_ttf
      pkgs.nerd-fonts.monaspace
      pkgs.nerd-fonts.inconsolata
      pkgs.nerd-fonts.fira-code
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-font-patcher
      pkgs.noto-fonts
      pkgs.noto-fonts-color-emoji
      pkgs.vistafonts
      pkgs.winePackages.fonts
    ];
  };

  # Theming packages
  environment.systemPackages = [
    # Cursor
    pkgs.hyprcursor
    # QT
    pkgs.libsForQt5.qtstyleplugin-kvantum
    pkgs.qt6Packages.qtstyleplugin-kvantum
    # Adwaita (i love gnome, but god damn is adwaita annoying on other DEs)
    pkgs.adwaita-icon-theme
    pkgs.libadwaita
  ];
}
