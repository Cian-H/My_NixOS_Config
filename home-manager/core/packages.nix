{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages = [
    pkgs.alejandra
    pkgs.git-extras
    pkgs.git-credential-manager
    pkgs.meld
    pkgs.unzip
    unstablePkgs.devenv
    unstablePkgs.lazygit
    unstablePkgs.nixd
    unstablePkgs.nushell
  ];
}
