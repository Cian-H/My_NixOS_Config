{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages =
    (with pkgs; [
      bitwarden
      blueman
      distrobox
      ferdium
      gimp-with-plugins
      github-desktop
      helix
      hyperfine
      imagemagick
      inkscape-with-extensions
      krita
      lynx
      neovide
      nwg-look
      obsidian
      obs-studio
      onlyoffice-desktopeditors
      pandoc
      pavucontrol
      podman-desktop
      podman-tui
      qimgv
      slack
      smile
      spotify
      vial
      vivaldi
      vivaldi-ffmpeg-codecs
      warpinator
      zathura
      zettlr
      # theming
      gtk-engine-murrine
      gtk_engines
      phinger-cursors
      tokyonight-gtk-theme
      # Python packages
      (python3.withPackages (
        python-pkgs: [
          python-pkgs.pip
          python-pkgs.pkginfo
          python-pkgs.python-lsp-server
          python-pkgs.setuptools
        ]
      ))
      # Backend dev tools
      go
      lua54Packages.lua
      luajitPackages.luarocks
      mypy
      php83
      poetry
      poetryPlugins.poetry-plugin-up
      poetryPlugins.poetry-plugin-export
      poetryPlugins.poetry-audit-plugin
      pre-commit
      rustup
      sshs
      steam-run
      stylua
      tree-sitter
      xarchiver
      # Language Server Protocols
      elixir-ls
      fortls
      nodePackages_latest.bash-language-server
      lua-language-server
      taplo
      yaml-language-server
      zed-editor
    ])
    ++ (with unstablePkgs; [
      nextcloud-client
      vimPlugins.mason-lspconfig-nvim
      zotero
    ])
    ++ [
      inputs.zen-browser.packages.x86_64-linux.default
    ];
}
