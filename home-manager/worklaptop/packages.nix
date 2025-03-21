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
    ])
    ++ (with unstablePkgs; [
      nextcloud-client
      vimPlugins.mason-lspconfig-nvim
      (writeShellScriptBin "obsidian" ''        # Patch for obsiidan GPU issues
               exec ${unstablePkgs.obsidian}/bin/obsidian --disable-gpu "$@"
      '')
      zed-editor
      zotero
    ])
    ++ [
      inputs.zen-browser.packages.x86_64-linux.default
    ];

  # manually add desktop file for patched obsidian
  home.file.".local/share/applications/obsidian.desktop".text = ''
    [Desktop Entry]
    Name=Obsidian
    Exec=${pkgs.writeShellScriptBin "obsidian-launcher" ''
      exec ${pkgs.obsidian}/bin/obsidian --disable-gpu "$@"
    ''}/bin/obsidian-launcher %U
    Icon=${pkgs.obsidian}/share/icons/hicolor/512x512/apps/obsidian.png
    Terminal=false
    Type=Application
    Categories=Office;
    MimeType=x-scheme-handler/obsidian;
    Keywords=obsidian;notes;
  '';
}
