{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages =
    (with pkgs; [
      alejandra
      git-extras
      git-credential-manager
      meld
      unzip
    ])
    ++ (with unstablePkgs; [
      devenv
      lazygit
      nixd
      nushell
    ]);
}
