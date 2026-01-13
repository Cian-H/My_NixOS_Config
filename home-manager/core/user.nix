{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  home = {
    username = "cianh";
    homeDirectory = "/home/cianh";
    shell.enableNushellIntegration = true;
  };
}
