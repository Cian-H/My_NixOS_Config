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
    initLua = ./yazi/init.lua;
    # plugins = {
    #   chmod = ./yazi/plugins/core/chmod.yazi;
    #   full-border = ./yazi/plugins/core/full-border.yazi;
    #   git = ./yazi/plugins/core/git.yazi;
    #   glow = ./yazi/plugins/glow.yazi;
    #   hexyl = ./yazi/plugins/hexyl.yazi;
    #   max-preview = ./yazi/plugins/core/max-preview.yazi;
    #   mime-ext = ./yazi/plugins/core/mime-ext.yazi;
    #   ouch = ./yazi/plugins/ouch.yazi;
    #   rich-preview = ./yazi/plugins/rich-preview.yazi;
    #   starship = ./yazi/plugins/starship.yazi;
    #   sudo = ./yazi/plugins/sudo.yazi;
    #   wl-clipboard = ./yazi/plugins/wl-clipboard.yazi;
    # };
    # flavors = {
    #   tokyo-night = ./yazi/flavors/tokyo-night.yazi;
    # };
    settings = {
      keymap = builtins.fromTOML (builtins.readFile ./yazi/keymap.toml);
      theme = builtins.fromTOML (builtins.readFile ./yazi/theme.toml);
      yazi = builtins.fromTOML (builtins.readFile ./yazi/yazi.toml);
    };
  };

  # Manually place plugins for now, until home-manager updates for newer yazi versions
  xdg.configFile = {
    "yazi/plugins/chmod.yazi".source = ./yazi/plugins/core/chmod.yazi;
    "yazi/plugins/full-border.yazi".source = ./yazi/plugins/core/full-border.yazi;
    "yazi/plugins/git.yazi".source = ./yazi/plugins/core/git.yazi;
    "yazi/plugins/glow.yazi".source = ./yazi/plugins/glow.yazi;
    "yazi/plugins/hexyl.yazi".source = ./yazi/plugins/hexyl.yazi;
    "yazi/plugins/max-preview.yazi".source = ./yazi/plugins/core/max-preview.yazi;
    "yazi/plugins/mime-ext.yazi".source = ./yazi/plugins/core/mime-ext.yazi;
    "yazi/plugins/ouch.yazi".source = ./yazi/plugins/ouch.yazi;
    "yazi/plugins/rich-preview.yazi".source = ./yazi/plugins/rich-preview.yazi;
    "yazi/plugins/starship.yazi".source = ./yazi/plugins/starship.yazi;
    "yazi/plugins/sudo.yazi".source = ./yazi/plugins/sudo.yazi;
    "yazi/plugins/wl-clipboard.yazi".source = ./yazi/plugins/wl-clipboard.yazi;
    "yazi/flavors/tokyo-night.yazi".source = ./yazi/flavors/tokyo-night.yazi;
  };
}
