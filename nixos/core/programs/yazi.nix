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
    };
    settings = {
      keymap = ./yazi/keymap.toml;
    };
  };
}
