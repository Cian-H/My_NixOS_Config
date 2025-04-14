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
    initLua = ./yazi/init.lua;
    plugins = {
      sudo = unstablePkgs.yaziPlugins.sudo;
      chmod = unstablePkgs.yaziPlugins.chmod;
      mime-ext = unstablePkgs.yaziPlugins.mime-ext;
      git = unstablePkgs.yaziPlugins.git;
      ouch = unstablePkgs.yaziPlugins.ouch;
      starship = unstablePkgs.yaziPlugins.starship;
      full-border = unstablePkgs.yaziPlugins.full-border;
      glow = unstablePkgs.yaziPlugins.glow;
      hexyl = ./yazi/plugins/hexyl.yazi;
      max-preview = ./yazi/plugins/max-preview.yazi;
    };
    flavors = {
      tokyo-night = ./yazi/flavors/tokyo-night.yazi;
    };
    settings = {
      keymap = builtins.fromTOML (builtins.readFile ./yazi/keymap.toml);
      theme = builtins.fromTOML (builtins.readFile ./yazi/theme.toml);
      yazi = builtins.fromTOML (builtins.readFile ./yazi/yazi.toml);
    };
  };
}
