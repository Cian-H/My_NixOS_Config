# This Is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, outputs
, lib
, config
, pkgs
, unstablePkgs
, ...
}:
let
  monaspaceFont = pkgs.callPackage ../modules/monaspice_font.nix { };
in
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix

    inputs.hyprcursor-phinger.homeManagerModules.hyprcursor-phinger
  ];

  home = {
    username = "cianh";
    homeDirectory = "/home/cianh";

    packages = (with pkgs; [
      alejandra
      bitwarden
      blueman
      cinnamon.warpinator
      ferdium
      gimp-with-plugins
      git-extras
      git-credential-manager
      github-desktop
      helix
      hyperfine
      imagemagick
      inkscape-with-extensions
      krita
      libreoffice
      lua53Packages.lua
      lynx
      meld
      mermaid-cli
      nixd
      nwg-look
      obs-studio
      pandoc
      pavucontrol
      podman-desktop
      podman-tui
      qimgv
      slack
      smile
      spotify
      vscode
      zathura
      zettlr
      # theming
      phinger-cursors
      tokyonight-gtk-theme
      # kitty extensions
      kitty-img
      kitty-themes
      # Python packages
      (python3.withPackages (
        python-pkgs: [
          python-pkgs.pip
          python-pkgs.pkginfo
          python-pkgs.python-lsp-server
          python-pkgs.pynvim
          python-pkgs.setuptools
        ]
      ))
      # Backend dev tools
      brotli
      cmake
      elixir
      erlang_26
      evcxr
      fortran-fpm
      gcc
      # gfortran
      gleam
      gnumake
      go
      julia
      lazygit
      luajitPackages.luarocks
      mypy
      niv
      php83
      poetry
      poetryPlugins.poetry-plugin-up
      poetryPlugins.poetry-plugin-export
      poetryPlugins.poetry-audit-plugin
      pre-commit
      rustup
      stylua
      tree-sitter
      uv
      xarchiver
      # Language Server Protocols
      elixir-ls
      fortls
      nodePackages_latest.bash-language-server
      lua-language-server
      ruff-lsp
      # rust-analyzer
      taplo
      yaml-language-server
    ]) ++ (with unstablePkgs; [
      vimPlugins.mason-lspconfig-nvim
      obsidian
      ruff
      rye
      steam-run-free
      zed-editor
      zotero
    ]) ++ [
      monaspaceFont
      inputs.zen-browser.packages.x86_64-linux.specific
    ];
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
    hyprcursor-phinger.enable = true;
  };
  services.swaync.enable = true;
  gtk = {
    enable = true;
    iconTheme = {
      name = "Tokyonight-Light";
      package = pkgs.tokyonight-gtk-theme;
    };
    theme = {
      name = "Tokyonight-Dark-BL-LB";
      package = pkgs.tokyonight-gtk-theme;
    };
    cursorTheme = {
      name = "phinger-cursors-dark";
      package = pkgs.phinger-cursors;
    };
  };

  home = {
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.11";
    file = {
      ".bashrc".source = ./dotfiles/.bashrc;
      "monaspice" = {
        source = "${monaspaceFont}/share/fonts/";
        target = ".local/share/fonts/monaspace-nerd-font";
      };
      "nushell" = {
        source = ./dotfiles/.config/nushell;
        target = ".config/nushell";
        recursive = true;
      };
      "nvim" = {
        source = ./dotfiles/.config/nvim;
        target = ".config/nvim";
        recursive = true;
      };
      "pypoetry" = {
        source = ./dotfiles/.config/pypoetry;
        target = ".config/pypoetry";
        recursive = true;
      };
      "Thunar" = {
        source = ./dotfiles/.config/Thunar;
        target = ".config/Thunar";
      };
      "rye" = {
        source = ./dotfiles/.config/.rye;
        target = ".config/.rye";
        recursive = true;
      };
    };
  };

  xdg = {
    # Set default applications
    mimeApps.defaultApplications = {
      "inode/directory" = "thunar.desktop";
      "application/zip" = "xarchiver.desktop";
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
    };
    configFile = {
      "home-manager".source = ../home-manager;
      "bat".source = ./dotfiles/.config/bat;
      "fastfetch".source = ./dotfiles/.config/fastfetch;
      "helix".source = ./dotfiles/.config/helix;
      "hypr" = {
        source = ./dotfiles/.config/hypr;
        recursive = true;
        # Here, we use OnChange, because we don't want the config to be mutable but we do want it to
        #   manage modifiable state at runtime
        onChange = ''
          rm -f ${config.xdg.configHome}/hypr/inputs.conf
          cp ${config.xdg.configHome}/hypr/HomeManagerInit_inputs.conf ${config.xdg.configHome}/hypr/inputs.conf
          chmod u+w ${config.xdg.configHome}/hypr/inputs.conf
        '';
      };
      "kitty".source = ./dotfiles/.config/kitty;
      "micro".source = ./dotfiles/.config/micro;
      "glow".source = ./dotfiles/.config/glow;
      "glamour".source = ./dotfiles/.config/glamour;
      "starship.toml".source = ./dotfiles/.config/starship.toml;
      "waybar".source = ./dotfiles/.config/waybar;
      "euporie".source = ./dotfiles/.config/euporie;
      "bottom".source = ./dotfiles/.config/bottom;
      "swaync".source = ./dotfiles/.config/swaync;
      "zellij".source = ./dotfiles/.config/zellij;
      "git".source = ./dotfiles/.config/git;
      "lazygit".source = ./dotfiles/.config/lazygit;
      "wezterm".source = ./dotfiles/.config/wezterm;
      "hg".source = ./dotfiles/.config/hg;
      "yazi".source = ./dotfiles/.config/yazi;
      "stylua.toml".source = ./dotfiles/.config/stylua.toml;
      "electron-flags.conf".source = ./dotfiles/.config/electron-flags.conf;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
