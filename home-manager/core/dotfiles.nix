{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  home.file =
    {
      ".bashrc".source = ./dotfiles/dot_bashrc;
      ".zshrc".source = ./dotfiles/dot_zshrc;
      ".local/bin/bash" = {
        source = ./dotfiles/dot_local/bin/bash;
        executable = true;
      };
      "nushell" = {
        source = ./dotfiles/dot_config/nushell;
        target = ".config/nushell/my_config";
        recursive = true;
      };
      "atuin" = {
        source = ./dotfiles/dot_config/atuin;
        target = ".config/atuin";
        recursive = true;
      };
      "fish" = {
        source = ./dotfiles/dot_config/fish;
        target = ".config/fish";
        recursive = true;
      };
      "nvim" = {
        source = lib.cleanSourceWith {
          src = ./dotfiles/dot_config/nvim;
          filter = name: type: let
            baseName = baseNameOf name;
          in
            ! (
              (lib.hasPrefix "*/nvim/*" name)
              || ((lib.hasPrefix "." baseName) && (baseName != ".hotpot.fnl"))
              || (lib.hasPrefix "devenv" baseName)
              || (lib.hasSuffix ".toml" baseName)
              || (lib.hasSuffix ".yml" baseName)
            );
        };
        target = ".config/nvim";
        recursive = true;
      };
      "helix" = {
        source = lib.cleanSourceWith {
          src = ./dotfiles/dot_config/helix;
          filter = name: type: let
            baseName = baseNameOf name;
          in
            ! (
              (lib.hasPrefix "*/helix/*" name)
              || (lib.hasPrefix "." baseName)
              || (lib.hasPrefix "devenv" baseName)
            );
        };
        target = ".config/helix";
        recursive = true;
      };
      "emacs" = {
        source = lib.cleanSourceWith {
          src = ./dotfiles/dot_config/emacs;
          filter = name: type: let
            baseName = baseNameOf name;
          in
            ! (
              (lib.hasPrefix "*/emacs/*" name)
              || (lib.hasPrefix "." baseName)
              || (lib.hasPrefix "devenv" baseName)
              || (lib.hasSuffix ".toml" baseName)
              || (lib.hasSuffix ".yml" baseName)
            );
        };
        target = ".config/emacs";
        recursive = true;
      };
      "noctalia" = {
        source = ./dotfiles/dot_config/noctalia;
        target = ".config/noctalia";
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
    };

  xdg.configFile = {
    "bat".source = ./dotfiles/dot_config/bat;
    "brush".source = ./dotfiles/dot_config/brush;
    "path.env".source = ./dotfiles/dot_config/path.env;
    "fastfetch".source = ./dotfiles/dot_config/fastfetch;
    "home-manager".source = ./dotfiles/dot_config/home-manager;
    "hypr".source = ./dotfiles/dot_config/hypr;
    "just".source = ./dotfiles/dot_config/just;
    "kitty".source = ./dotfiles/dot_config/kitty;
    "ghostty".source = ./dotfiles/dot_config/ghostty;
    "micro".source = ./dotfiles/dot_config/micro;
    "niri".source = ./dotfiles/dot_config/niri;
    "nushell/lsp.nu".text = ''
      source ~/.config/nushell/my_config/lsp.nu
    '';
    "neovide".source = ./dotfiles/dot_config/neovide;
    "glow".source = ./dotfiles/dot_config/glow;
    "glamour".source = ./dotfiles/dot_config/glamour;
    "starship.toml".source = ./dotfiles/dot_config/starship.toml;
    "elephant/websearch.toml".source = ./dotfiles/dot_config/elephant/websearch.toml;
    "walker".source = ./dotfiles/dot_config/walker;
    "waybar".source = ./dotfiles/dot_config/waybar;
    # "euporie".source = ./dotfiles/dot_config/euporie;
    "bottom".source = ./dotfiles/dot_config/bottom;
    "swaync".source = ./dotfiles/dot_config/swaync;
    "zellij".source = ./dotfiles/dot_config/zellij;
    "git".source = ./dotfiles/dot_config/git;
    "lazygit".source = ./dotfiles/dot_config/lazygit;
    "wezterm".source = ./dotfiles/dot_config/wezterm;
    "alacritty".source = ./dotfiles/dot_config/alacritty;
    "hg".source = ./dotfiles/dot_config/hg;
    "stylua.toml".source = ./dotfiles/dot_config/stylua.toml;
    "electron-flags.conf".source = ./dotfiles/dot_config/electron-flags.conf;
    "foot".source = ./dotfiles/dot_config/foot;
  };
}
