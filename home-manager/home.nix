# This Is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: let
  monaspaceFont = pkgs.callPackage ../modules/monaspice_font.nix {};
in {
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

    packages =
      (with pkgs; [
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
        lynx
        meld
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
        zathura
        zettlr
        # theming
        phinger-cursors
        tokyonight-gtk-theme
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
        lazygit
        vimPlugins.mason-lspconfig-nvim
        obsidian
        zed-editor
        zotero
        # kitty extensions
        kitty-img
        kitty-themes
      ])
      ++ [
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
      ".bashrc".source = ./dotfiles/dot_bashrc;
      "monaspice" = {
        source = "${monaspaceFont}/share/fonts/";
        target = ".local/share/fonts/";
        recursive = true;
      };
      "nushell" = {
        source = ./dotfiles/dot_config/nushell;
        target = ".config/nushell";
        recursive = true;
      };
      "nvim" = {
        source = ./dotfiles/dot_config/nvim;
        target = ".config/nvim";
        recursive = true;
      };
      "pypoetry" = {
        source = ./dotfiles/dot_config/pypoetry;
        target = ".config/pypoetry";
        recursive = true;
      };
      "Thunar" = {
        source = ./dotfiles/dot_config/Thunar;
        target = ".config/Thunar";
      };
      "rye" = {
        source = ./dotfiles/dot_config/.rye;
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
      "bat".source = ./dotfiles/dot_config/bat;
      "fastfetch".source = ./dotfiles/dot_config/fastfetch;
      "helix".source = ./dotfiles/dot_config/helix;
      "hypr" = {
        source = ./dotfiles/dot_config/hypr;
        recursive = true;
        # Here, we use OnChange, because we don't want the config to be mutable but we do want it to
        #   manage modifiable state at runtime
        onChange = ''
          rm -f ${config.xdg.configHome}/hypr/inputs.conf
          cp ${config.xdg.configHome}/hypr/HomeManagerInit_inputs.conf ${config.xdg.configHome}/hypr/inputs.conf
          chmod u+w ${config.xdg.configHome}/hypr/inputs.conf
        '';
      };
      "kitty".source = ./dotfiles/dot_config/kitty;
      "micro".source = ./dotfiles/dot_config/micro;
      "neovide".source = ./dotfiles/dot_config/neovide;
      "glow".source = ./dotfiles/dot_config/glow;
      "glamour".source = ./dotfiles/dot_config/glamour;
      "starship.toml".source = ./dotfiles/dot_config/starship.toml;
      "waybar".source = ./dotfiles/dot_config/waybar;
      "euporie".source = ./dotfiles/dot_config/euporie;
      "bottom".source = ./dotfiles/dot_config/bottom;
      "swaync".source = ./dotfiles/dot_config/swaync;
      "zellij".source = ./dotfiles/dot_config/zellij;
      "git".source = ./dotfiles/dot_config/git;
      "lazygit".source = ./dotfiles/dot_config/lazygit;
      "wezterm".source = ./dotfiles/dot_config/wezterm;
      "hg".source = ./dotfiles/dot_config/hg;
      "yazi".source = ./dotfiles/dot_config/yazi;
      "stylua.toml".source = ./dotfiles/dot_config/stylua.toml;
      "electron-flags.conf".source = ./dotfiles/dot_config/electron-flags.conf;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
