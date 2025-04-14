{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;
    withRuby = true;
  };
}
