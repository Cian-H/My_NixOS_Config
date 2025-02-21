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
      vikunja-db_password = {};
      vikunja-db_rootpassword = {};
      nextcloud_admin_password = {};
      nextcloud-db_password = {};
      nextcloud-db_rootpassword = {};
      nextcloud_fulltextsearch_password = {};
      nextcloud_imaginary_secret = {};
      nextcloud_onlyoffice_secret = {};
      nextcloud_recording_secret = {};
      nextcloud_redis_host_password = {};
      nextcloud_signaling_secret = {};
      nextcloud_turn_secret = {};
      nextcloud_whiteboard_secret = {};
      nextcloud-collabora_password = {};
    };
  };
}
