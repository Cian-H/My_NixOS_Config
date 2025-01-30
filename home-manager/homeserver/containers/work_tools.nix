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
        VIKUNJA_SERVICE_JWTSECRET = config.sops.secrets.vikunja_jwtsecret.path;
        VIKUNJA_SERVICE_PUBLICURL = "http://bulba.space/";
        VIKUNJA_DATABASE_PATH = "/db/vikunja.db";
      };
      volumes = [
        "/home/cianh/vikunja/files:/app/vikunja/files"
        "/home/cianh/vikunja/db:/db"
      ];
      ports = ["3456:3456"];
    };
    freshrss = {
      image = "docker.io/freshrss/freshrss:latest";
      autoUpdate = "registry";
      environment = {
        TZ = "Europe/Dublin";
        CRON_MIN = "1,31";
      };
      volumes = [
        "/home/cianh/freshrss/data:/var/www/FreshRSS/data"
        "/home/cianh/freshrss/extensions:/var/www/FreshRSS/extensions"
      ];
      ports = ["3457:80"];
      extraPodmanArgs = [
        "--log-opt max-size=10m"
      ];
    };
  };
}
