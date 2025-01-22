{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  imports = [
    ./core/dotfiles.nix
    ./core/user.nix
    ./core/packages.nix
    ./core/programs.nix
    inputs.hyprcursor-phinger.homeManagerModules.hyprcursor-phinger
  ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
