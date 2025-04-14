{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  environment = {
    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };
    etc =
      lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;
  };
}
