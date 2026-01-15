{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  theme,
  ...
}: let
  username = "cianh";
in {
  # Activate DEs
  programs = {
    uwsm = {
      enable = true;
      waylandCompositors.hyprland.binPath = lib.mkForce "/run/current-system/sw/bin/start-hyprland";
    };
    regreet = {
      enable = true;
      theme = {
        name = theme.theme.name;
        package = theme.theme.package;
      };
      cursorTheme = {
        name = theme.cursorTheme.name;
        package = theme.cursorTheme.package;
      };
      iconTheme.name = "Adwaita";
      # iconTheme = {
      #   name = theme.iconTheme.name;
      #   package = theme.iconTheme.package;
      # };
      font = {
        name = "Noto Sans";
        size = 16;
        package = pkgs.noto-fonts;
      };
      settings = {
        GTK.application_prefer_dark_theme = true;
        appearance.greeting_msg = "Hello ${username}, welcome back to '${config.networking.hostName}'!";
        background.path = theme.wallpaper;
      };
    };
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    iio-hyprland.enable = true;

    # Enable my preferred DE utilities
    thunar = {
      enable = true;
      plugins = [
        pkgs.xfce.thunar-volman
        pkgs.xfce.thunar-archive-plugin
        pkgs.xfce.thunar-media-tags-plugin
      ];
    };
    xfconf.enable = true;

    # Disable automatically activated programs i dont want
    foot.enable = false;

    # Lets also activate some handy devenv tools
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    nix-ld = {
      enable = true;
      libraries = [
        pkgs.acl
        pkgs.alsa-lib
        pkgs.at-spi2-core
        pkgs.attr
        pkgs.bzip2
        pkgs.curl
        pkgs.dbus
        pkgs.eget
        pkgs.expat
        pkgs.glib
        pkgs.libsodium
        pkgs.libssh
        pkgs.libxml2
        pkgs.nspr
        pkgs.nss
        pkgs.openssl
        pkgs.pango
        pkgs.stdenv.cc
        pkgs.systemd
        pkgs.util-linux
        pkgs.vulkan-loader
        pkgs.xz
        pkgs.zlib
        pkgs.zstd
      ];
    };

    seahorse.enable = true; # enable the graphical frontend
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gnome3;
      enableSSHSupport = true;
    };
    virt-manager.enable = true;
  };
}
