{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  # Activate DEs
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.sway = {
    enable = true;
    extraOptions = ["--unsupported-gpu"];
  };
  programs.waybar.enable = true;

  # Enable my preferred DE utilities
  programs.thunar.enable = true;
  programs.thunar.plugins = [
    pkgs.xfce.thunar-volman
    pkgs.xfce.thunar-archive-plugin
    pkgs.xfce.thunar-media-tags-plugin
  ];
  programs.xfconf.enable = true;

  # Disable automatically activated programs i dont want
  programs.foot.enable = false;

  # Lets also activate some handy devenv tools
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.nix-ld = {
    enable = true;
    libraries = [
      pkgs.acl
      pkgs.alsa-lib
      pkgs.at-spi2-core
      pkgs.attr
      pkgs.bzip2
      pkgs.curl
      pkgs.dbus
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

  programs.seahorse.enable = true; # enable the graphical frontend
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    enableSSHSupport = true;
  };
  programs.virt-manager.enable = true;
}
