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
    ./core.nix
    ./homeserver/packages.nix
    ./homeserver/programs.nix
    ./homeserver/containers.nix
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    age.keyFile = "/home/cianh/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      vikunja_jwtsecret = {};
      vikunja_dbpassword = {};
      vikunja-db_rootpassword = {};
    };
  };
}
