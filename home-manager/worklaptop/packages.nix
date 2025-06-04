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
    pkgs.ferdium
    pkgs.github-desktop
    pkgs.helix
    pkgs.hyperfine
    pkgs.imagemagick
    pkgs.inkscape-with-extensions
    pkgs.krita
    pkgs.lynx
    pkgs.neovide
    pkgs.nwg-look
    pkgs.obsidian
    pkgs.obs-studio
    pkgs.onlyoffice-desktopeditors
    pkgs.pandoc
    pkgs.pavucontrol
    pkgs.podman-desktop
    pkgs.podman-tui
    pkgs.slack
    pkgs.smile
    pkgs.spotify
    pkgs.vial
    vivaldi-wayland
    pkgs.vivaldi-ffmpeg-codecs
    pkgs.warpinator
    pkgs.zathura
    pkgs.zed-editor
    pkgs.zettlr
    unstablePkgs.gimp3-with-plugins
    unstablePkgs.nextcloud-client
    unstablePkgs.zotero
    inputs.zen-browser.packages.x86_64-linux.default
    # theming
    pkgs.gtk-engine-murrine
    pkgs.gtk_engines
    pkgs.phinger-cursors
    pkgs.tokyonight-gtk-theme
    # Python packages
    (pkgs.python3.withPackages (
      python-pkgs: [
        python-pkgs.pip
        python-pkgs.pkginfo
        python-pkgs.python-lsp-server
        python-pkgs.setuptools
      ]
    ))
    # Backend dev tools
    pkgs.go
    pkgs.lua54Packages.lua
    pkgs.luajitPackages.luarocks
    pkgs.mypy
    pkgs.php83
    pkgs.poetry
    pkgs.poetryPlugins.poetry-plugin-up
    pkgs.poetryPlugins.poetry-plugin-export
    pkgs.poetryPlugins.poetry-audit-plugin
    pkgs.pre-commit
    pkgs.rustup
    pkgs.sshs
    pkgs.steam-run
    pkgs.stylua
    pkgs.tree-sitter
    pkgs.xarchiver
    # Language Server Protocols
    pkgs.elixir-ls
    pkgs.fortls
    pkgs.nodePackages_latest.bash-language-server
    pkgs.lua-language-server
    pkgs.taplo
    pkgs.yaml-language-server
    unstablePkgs.vimPlugins.mason-lspconfig-nvim
  ];
}
