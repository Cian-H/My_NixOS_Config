{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  services.home-manager.autoExpire = {
    enable = true;
    store.cleanup = true;
  };
}
