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
  python = pkgs.python314.withPackages (
    python-pkgs: [
      python-pkgs.pkginfo
      python-pkgs.setuptools
    ]
  );
in {
  home.packages = [
    pkgs.bitwarden-desktop
    pkgs.bat-extras.batman
    pkgs.bat-extras.batdiff
    pkgs.bat-extras.batgrep
    pkgs.bat-extras.prettybat
    pkgs.blueman
    pkgs.broot
    pkgs.clapper
    pkgs.cliphist
    pkgs.distrobox
    pkgs.dvc
    pkgs.feh
    pkgs.git-lfs
    pkgs.go
    pkgs.has
    pkgs.hyperfine
    pkgs.imagemagick
    pkgs.jujutsu
    pkgs.kubectl
    pkgs.lnav
    pkgs.lynx
    pkgs.minikube
    unstablePkgs.mission-center
    pkgs.neovide
    pkgs.nix-output-monitor
    pkgs.nix-tree
    pkgs.nh
    pkgs.nodejs_24
    pkgs.nwg-look
    unstablePkgs.obsidian
    pkgs.onlyoffice-desktopeditors
    pkgs.pandoc
    pkgs.pavucontrol
    unstablePkgs.podman-compose
    unstablePkgs.podman-desktop
    unstablePkgs.podman-tui
    pkgs.popsicle
    python
    unstablePkgs.ruff
    pkgs.smile
    pkgs.sshs
    unstablePkgs.uv
    pkgs.vial
    vivaldi-wayland
    unstablePkgs.visidata
    pkgs.vivaldi-ffmpeg-codecs
    pkgs.warpinator
    pkgs.xarchiver
    pkgs.zathura
    unstablePkgs.zeal
    unstablePkgs.zed-editor
    unstablePkgs.zotero
    inputs.zen-browser.packages.x86_64-linux.default
    # theming
    pkgs.adwaita-icon-theme
    pkgs.gtk-engine-murrine
    pkgs.gtk_engines
    pkgs.hicolor-icon-theme
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
