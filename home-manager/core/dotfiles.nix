{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  home.file = {
    ".bashrc" = lib.mkIf (!config.programs.bash.enable) {
      source = ./dotfiles/dot_bashrc;
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

  xdg.configFile = {
    "bat".source = ./dotfiles/dot_config/bat;
    "fastfetch".source = ./dotfiles/dot_config/fastfetch;
    "helix".source = ./dotfiles/dot_config/helix;
    "home-manager".source = ./dotfiles/dot_config/home-manager;
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
    "just".source = ./dotfiles/dot_config/just;
    "kitty".source = ./dotfiles/dot_config/kitty;
    "ghostty".source = ./dotfiles/dot_config/ghostty;
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
    "alacritty".source = ./dotfiles/dot_config/alacritty;
    "hg".source = ./dotfiles/dot_config/hg;
    "stylua.toml".source = ./dotfiles/dot_config/stylua.toml;
    "electron-flags.conf".source = ./dotfiles/dot_config/electron-flags.conf;
    "Kvantum".source = ./dotfiles/dot_config/Kvantum;
    "foot".source = ./dotfiles/dot_config/foot;
  };
}
