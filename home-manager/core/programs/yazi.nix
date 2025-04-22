{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  programs.yazi = {
    enable = true;
    package = unstablePkgs.yazi;
    enableNushellIntegration = true;
  };

  # Manually place plugins for now, until home-manager updates for newer yazi versions
  xdg.configFile = {
    "yazi/init.lua".source = ../dotfiles/dot_config/yazi/init.lua;
    "yazi/keymap.toml".source = ../dotfiles/dot_config/yazi/keymap.toml;
    "yazi/theme.toml".source = ../dotfiles/dot_config/yazi/theme.toml;
    "yazi/yazi.toml".source = ../dotfiles/dot_config/yazi/yazi.toml;
    "yazi/plugins/chmod.yazi".source = ../dotfiles/dot_config/yazi/plugins/core/chmod.yazi;
    "yazi/plugins/full-border.yazi".source = ../dotfiles/dot_config/yazi/plugins/core/full-border.yazi;
    "yazi/plugins/git.yazi".source = ../dotfiles/dot_config/yazi/plugins/core/git.yazi;
    "yazi/plugins/glow.yazi".source = ../dotfiles/dot_config/yazi/plugins/glow.yazi;
    "yazi/plugins/hexyl.yazi".source = ../dotfiles/dot_config/yazi/plugins/hexyl.yazi;
    "yazi/plugins/max-preview.yazi".source = ../dotfiles/dot_config/yazi/plugins/max-preview.yazi;
    "yazi/plugins/mime-ext.yazi".source = ../dotfiles/dot_config/yazi/plugins/core/mime-ext.yazi;
    "yazi/plugins/ouch.yazi".source = ../dotfiles/dot_config/yazi/plugins/ouch.yazi;
    "yazi/plugins/rich-preview.yazi".source = ../dotfiles/dot_config/yazi/plugins/rich-preview.yazi;
    "yazi/plugins/starship.yazi".source = ../dotfiles/dot_config/yazi/plugins/starship.yazi;
    "yazi/plugins/sudo.yazi".source = ../dotfiles/dot_config/yazi/plugins/sudo.yazi;
    "yazi/plugins/wl-clipboard.yazi".source = ../dotfiles/dot_config/yazi/plugins/wl-clipboard.yazi;
    "yazi/flavors/tokyo-night.yazi".source = ../dotfiles/dot_config/yazi/flavors/tokyo-night.yazi;
  };
}
