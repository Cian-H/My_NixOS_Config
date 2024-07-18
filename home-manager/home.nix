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
      bitwarden
      bitwarden-cli
      blueman
      caffeine-ng
      chromium
      cinnamon.warpinator
      delta
      feh
      ferdium
      gimp-with-plugins
      git-extras
      github-desktop
      glow
      gnome.gnome-boxes
      helix
      hyperfine
      imagemagick
      inkscape-with-extensions
      krita
      libreoffice
      lua51Packages.lua
      lynx
      marker
      mendeley
      mermaid-cli
      navi
      nixd
      nwg-look
      obs-studio
      pandoc
      pavucontrol
      podman-desktop
      podman-tui
      slack
      spice-vdagent
      spotify
      steam-run
      vscode
      # theming
      phinger-cursors
      tokyo-night-gtk
      # gnome extensions
      gnome.gnome-tweaks
      gnome.dconf-editor
      gnomeExtensions.caffeine
      gnomeExtensions.freon
      gnomeExtensions.smile-complementary-extension
      gnomeExtensions.user-themes
      # kitty extensions
      kitty-img
      kitty-themes
      # Python packages
      pypy3
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
      nil
      niv
      nixpkgs-fmt
      ouch
      passh
      php83
      poetry
      poetryPlugins.poetry-plugin-up
      poetryPlugins.poetry-plugin-export
      poetryPlugins.poetry-audit-plugin
      pre-commit
      rm-improved
      ruff
      rustup
      starship
      stylua
      tree-sitter
      wget
      wl-clipboard
      (vivaldi.override {
        proprietaryCodecs = true;
        enableWidevine = true;
      })
      vivaldi-ffmpeg-codecs
      widevine-cdm
      xclip
      zathura
      zellij
      zettlr
      # Language Server Protocols
      elixir-ls
      fortls
      nodePackages_latest.bash-language-server
      lua-language-server
      ruff-lsp
      # rust-analyzer
      taplo
      yaml-language-server
      zed-editor
    ]) ++ (with unstablePkgs; [
      vimPlugins.mason-lspconfig-nvim
      obsidian
      jujutsu
      zotero
    ]) ++ [
      monaspaceFont
    ];
  };

  # Enable programs and modules
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.hyprcursor-phinger.enable = true;

  # Properly install custom fonts
  home.file."monaspice" = {
    source = "${monaspaceFont}/.local/share/fonts/monaspace-nerd-font";
    target = ".local/share/fonts/monaspace-nerd-font";
    recursive = true;
  };

  # Symlink dotfiles (managed this way so i can easily move back to stow if i want)
  # First, symlink home-manager to where it expects to be
  xdg.configFile."home-manager" = {
    source = ../home-manager;
    recursive = true;
  };
  # Then, the rest of the dotfiles
  xdg.configFile."bat" = {
    source = ./dotfiles/.config/bat;
    recursive = true;
  };
  xdg.configFile."fastfetch" = {
    source = ./dotfiles/.config/fastfetch;
    recursive = true;
  };
  xdg.configFile."helix" = {
    source = ./dotfiles/.config/helix;
    recursive = true;
  };
  xdg.configFile."hypr" = {
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
  xdg.configFile."kitty" = {
    source = ./dotfiles/.config/kitty;
    recursive = true;
  };
  xdg.configFile."micro" = {
    source = ./dotfiles/.config/micro;
    recursive = true;
  };
  # We enable nushell using `home.file` instead because this makes it mutable.
  # `xdg.configFile` makes the dir readonly, causing the shell to crash as it can't write to history.
  home.file."nushell" = {
    source = ./dotfiles/.config/nushell;
    target = ".config/nushell";
    recursive = true;
  };
  # Neovim also needs to be mutable, since we're managing it using lazy.
  home.file."nvim" = {
    source = ./dotfiles/.config/nvim;
    target = ".config/nvim";
    recursive = true;
  };
  # Similar situation to nushell here. Needs to be read/write so we can manage plugins
  # However, in this case the files themselves also need to be read/write so making a symlink
  home.file."pypoetry" = {
    source = ./dotfiles/.config/pypoetry;
    target = ".config/pypoetry";
    recursive = true;
  };
  xdg.configFile."starship.toml".source = ./dotfiles/.config/starship.toml;
  xdg.configFile."waybar" = {
    source = ./dotfiles/.config/waybar;
    recursive = true;
  };
  xdg.configFile."euporie" = {
    source = ./dotfiles/.config/euporie;
    recursive = true;
  };
  xdg.configFile."bottom" = {
    source = ./dotfiles/.config/bottom;
    recursive = true;
  };
  xdg.configFile."swaync" = {
    source = ./dotfiles/.config/swaync;
    recursive = true;
  };
  xdg.configFile."zellij" = {
    source = ./dotfiles/.config/zellij;
    recursive = true;
  };
  xdg.configFile."lazygit" = {
    source = ./dotfiles/.config/lazygit;
    recursive = true;
  };
  xdg.configFile."wezterm" = {
    source = ./dotfiles/.config/wezterm;
    recursive = true;
  };
  xdg.configFile."electron-flags.conf".source = ./dotfiles/.config/electron-flags.conf;
  home.file.".bashrc".source = ./dotfiles/.bashrc;
  home.file.".gitconfig".source = ./dotfiles/.gitconfig;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
