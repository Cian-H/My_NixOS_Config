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
      waylandCompositors.hyprland = {
        binPath = lib.mkForce "/run/current-system/sw/bin/start-hyprland";
        prettyName = "Hyprland";
        comment = "Hyprland managed by UWSM";
      };
    };
    noctalia-greeter = {
      enable = true;
      settings = {
        session.default = "Hyprland (uwsm-managed)";
        user.default = username;
        appearance = {
          scheme = "Tokyo-Night";
          theme_mode = "dark";
          font_family = "MonaspiceNe Nerd Font";
          wallpaper = {
            path = theme.wallpaper;
            fill_mode = "crop";
          };
        };
        cursor = {
          theme = theme.cursorTheme.name;
          size = 24;
        };
        keyboard = {
          layout = "ie";
        };
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
        pkgs.thunar-volman
        pkgs.thunar-archive-plugin
        pkgs.thunar-media-tags-plugin
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
    yubikey-touch-detector = {
      enable = true;
      libnotify = true;
    };
  };
}
