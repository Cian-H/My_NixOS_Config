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

    packages = with pkgs; [
      corefonts
      liberation_ttf
      nerdfonts
      nerd-font-patcher
      noto-fonts
      noto-fonts-color-emoji
      vistafonts
      winePackages.fonts
    ];
  };

  # Theming packages
  environment.systemPackages = with pkgs; [
    # Cursor
    hyprcursor
    # QT
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
    # Adwaita (i love gnome, but god damn is adwaita annoying on other DEs)
    adwaita-icon-theme
    libadwaita
  ];
}
