{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  services.podman.containers = {
    vikunja = {
      image = "docker.io/vikunja/vikunja:latest";
      autoUpdate = "registry";
      environment = {
        VIKUNJA_SERVICE_JWTSECRET = config.sops.secrets.vikunja_jwt_secret.path;
        VIKUNJA_SERVICE_PUBLICURL = "http://bulba.space/";
        VIKUNJA_DATABASE_PATH = "/db/vikunja.db";
      };
      environmentFiles = [
        config.sops.secrets.vikunja_jwt_secret.path
      ];
      volumes = [
        "/home/cianh/vikunja/files:/app/vikunja/files"
        "/home/cianh/vikunja/db:/db"
      ];
      ports = ["3456:3456"];
    };
  };
}
