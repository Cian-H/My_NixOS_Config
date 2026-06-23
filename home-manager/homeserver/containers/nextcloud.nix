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
      nextcloud-net = {};
    };
    containers = {
      nextcloud = {
        image = "docker.io/library/nextcloud:fpm-alpine";
        autoUpdate = "registry";
        network = [
          "nextcloud-net"
          "proxy-net"
        ];
        environment = {
          NEXTCLOUD_URL = "nextcloud.bulba.space";
          TRUSTED_DOMAINS = "nextcloud.bulba.space";
          TRUSTED_PROXIES = "192.168.12.254";
          MYSQL_HOST = "nextcloud-db";
          MYSQL_DATABASE = "nextcloud";
          MYSQL_USER = "nextcloud";
          MYSQL_PASSWORD = config.sops.secrets.nextcloud-db_password.path;
          REDIS_HOST = "nextcloud-redis";
        };
        volumes = [
          "/home/cianh/Nextcloud/:/var/www/html"
        ];
        extraConfig = {
          Unit = {
            After = [ "podman-nextcloud-db.service" "podman-nextcloud-redis.service" ];
            Requires = [ "podman-nextcloud-db.service" "podman-nextcloud-redis.service" ];
          };
        };
      };
      nextcloud-db = {
        image = "docker.io/library/mariadb:11.4.5";
        autoUpdate = "registry";
        network = ["nextcloud-net"];
        environment = {
          MYSQL_DATABASE = "nextcloud";
          MYSQL_USER = "nextcloud";
          MYSQL_PASSWORD = config.sops.secrets.nextcloud-db_password.path;
          MYSQL_ROOT_PASSWORD = config.sops.secrets.nextcloud-db_rootpassword.path;
        };
        volumes = [
          "/home/cianh/nextcloud_db:/var/lib/mysql"
        ];
      };
      nextcloud-redis = {
        image = "docker.io/library/redis:alpine";
        autoUpdate = "registry";
        network = ["nextcloud-net"];
      };
      nextcloud-collabora = {
        image = "docker.io/collabora/code:latest";
        autoUpdate = "registry";
        network = [
          "nextcloud-net"
          "proxy-net"
        ];
        environment = {
          username = "admin";
          password = config.sops.secrets.nextcloud-collabora_password.path;
          aliasgroup1 = "https://nextcloud.bulba.space";
          aliasgroup2 = "https://collabora.bulba.space";
          server_name = "collabora.bulba.space";
        };
      };
    };
  };

  systemd.user.services.nextcloud-cron = {
    Unit = {
      Description = "Nextcloud cron.php job";
      Requires = [ "podman-nextcloud.service" ];
      After = [ "podman-nextcloud.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.podman}/bin/podman exec --user www-data nextcloud php -f /var/www/html/cron.php";
    };
  };

  systemd.user.timers.nextcloud-cron = {
    Unit = {
      Description = "Run Nextcloud cron.php every 5 minutes";
    };
    Timer = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
      Unit = "nextcloud-cron.service";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
