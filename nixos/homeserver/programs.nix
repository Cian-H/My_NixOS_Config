{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-tty;
    enableSSHSupport = true;
  };
}
