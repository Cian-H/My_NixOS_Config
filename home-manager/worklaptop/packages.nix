{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: let
  # Patch vivaldi to ensure reliability on wayland
  vivaldi-wayland = pkgs.symlinkJoin {
    name = "vivaldi-wayland";
    paths = [pkgs.vivaldi];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/vivaldi \
        --set NIXOS_OZONE_WL 1 \
        --add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform --ozone-platform-hint=auto"
    '';
  };
in {
  home.packages = [
    pkgs.bitwarden
    pkgs.blueman
    pkgs.distrobox
    pkgs.feh
    pkgs.has
    pkgs.hyperfine
    pkgs.imagemagick
    pkgs.kubectl
    pkgs.lynx
    pkgs.minikube
    pkgs.neovide
    pkgs.nwg-look
    unstablePkgs.obsidian
    pkgs.onlyoffice-desktopeditors
    pkgs.pandoc
    pkgs.pavucontrol
    pkgs.podman-compose
    pkgs.podman-desktop
    pkgs.smile
    pkgs.sshs
    pkgs.vial
    vivaldi-wayland
    pkgs.vivaldi-ffmpeg-codecs
    pkgs.warpinator
    pkgs.xarchiver
    pkgs.zathura
    pkgs.zettlr
    unstablePkgs.zed-editor
    unstablePkgs.zotero
    inputs.zen-browser.packages.x86_64-linux.default
    # theming
    pkgs.gtk-engine-murrine
    pkgs.gtk_engines
    pkgs.phinger-cursors
    pkgs.tokyonight-gtk-theme
    # Backend dev tools
    pkgs.lua54Packages.lua
    pkgs.luajitPackages.luarocks
    pkgs.steam-run
    pkgs.tree-sitter
    unstablePkgs.vimPlugins.mason-lspconfig-nvim
  ];
}
