# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  # imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  # ];

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "cianh";
    homeDirectory = "/home/cianh";
    packages = with pkgs; [
      bitwarden
      bitwarden-cli
      caffeine-ng
      cinnamon.warpinator
      feh
      ferdium
      gimp-with-plugins
      github-desktop
      glow
      gnome.gnome-boxes
      helix
      hyperfine
      imagemagick
      inkscape-with-extensions
      krita
      libreoffice
      lynx
      marker
      mendeley
      mermaid-cli
      nwg-look
      obs-studio
      pandoc
      podman-desktop
      podman-tui
      slack
      spice-vdagent
      spotify
      steam-run
      tmux
      vivaldi
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
      # Neovim extensions
      vimPlugins.mason-lspconfig-nvim
      # Python packages
      pypy3
      (python3.withPackages(
        python-pkgs: [
          python-pkgs.pip
          python-pkgs.python-lsp-server
          python-pkgs.pynvim
        ]
      ))
      # python310
      # python311
      # python312
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
      jujutsu
      julia
      luajitPackages.luarocks
      mypy
      nil
      nixpkgs-fmt
      php83
      php83Packages.composer
      poetry
      pre-commit
      rm-improved
      ruff
      rustup
      starship
      stylua
      tree-sitter
      wget
      xclip
      zulu
      # Language Server Protocols
      elixir-ls
      fortls
      nodePackages_latest.bash-language-server
      lua-language-server
      ruff-lsp
      # rust-analyzer
      taplo
      yaml-language-server
    ];
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Symlink detfiles (managed this way so i can easily move back to stow if i want)
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
  xdg.configFile."pypoetry" = {
    source = ./dotfiles/.config/pypoetry;
    recursive = true;
  };
  xdg.configFile."starship.toml".source = ./dotfiles/.config/starship.toml;
  xdg.configFile."waybar" = {
    source = dotfiles/.config/waybar;
    recursive = true;
  };
  home.file.".bashrc".source = ./dotfiles/.bashrc;
  home.file.".gitconfig".source = ./dotfiles/.gitconfig;
  home.file.".local/share/fonts/Monaspace-Nerd-Font".source = ./dotfiles/.local/share/fonts/Monaspace-Nerd-Font;
  home.file.".local/share/icons/phinger-hyprcursor".source = ./dotfiles/.local/share/icons/phinger-hyprcursor;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
