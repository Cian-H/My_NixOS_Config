{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  services.podman = {
    networks = {
      vikunja-net = {};
    };
    containers = {
      vikunja = {
        image = "docker.io/vikunja/vikunja:latest";
        autoUpdate = "registry";
        network = [
          "vikunja-net"
          "proxy-net"
        ];
        environment = {
          VIKUNJA_SERVICE_JWTSECRET = config.sops.secrets.vikunja_jwtsecret.path;
          VIKUNJA_SERVICE_PUBLICURL = "https://vikunja.bulba.space";
          VIKUNJA_FRONTEND_BASE = "/vikunja";
          VIKUNJA_SERVICE_FRONTENDURL = "https://vikunja.bulba.space";
          VIKUNJA_DATABASE_PATH = "/db/vikunja.db";
          VIKUNJA_DATABASE_TYPE = "mysql";
          VIKUNJA_DATABASE_DATABASE = "vikunja";
          VIKUNJA_DATABASE_HOST = "vikunja-db";
          VIKUNJA_DATABASE_USER = "vikunja";
          VIKUNJA_DATABASE_PASSWORD = config.sops.secrets.vikunja-db_password.path;
        };
        volumes = [
          "/home/cianh/vikunja/files:/app/vikunja/files"
        ];
        ports = ["3456:3456"];
        extraConfig = {
          Unit = {
            After = "podman-vikunja-db.service";
            Requires = "podman-vikunja-db.service";
          };
        };
      };
      vikunja-db = {
        image = "docker.io/library/mariadb:10";
        autoUpdate = "registry";
        network = "vikunja-net";
        exec = "--character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci";
        environment = {
          MYSQL_ROOT_PASSWORD = config.sops.secrets.vikunja-db_rootpassword.path;
          MYSQL_USER = "vikunja";
          MYSQL_PASSWORD = config.sops.secrets.vikunja-db_password.path;
          MYSQL_DATABASE = "vikunja";
        };
        volumes = [
          "/home/cianh/vikunja/db:/var/lib/mysql"
        ];
      };
      freshrss = {
        image = "docker.io/freshrss/freshrss:latest";
        autoUpdate = "registry";
        network = "proxy-net";
        environment = {
          TZ = "Europe/Dublin";
          CRON_MIN = "1,31";
          TRUSTED_PROXY = "caddy";
          FRESHRSS_ENV = "production";
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
  };
}
