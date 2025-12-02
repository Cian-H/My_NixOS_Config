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
        };
        volumes = [
          "/home/cianh/Nextcloud/:/var/www/html"
        ];
        extraConfig = {
          Unit = {
            After = "podman-nextcloud-db.service";
            Requires = "podman-nextcloud-db.service";
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
      nextcloud-collabora = {
        image = "docker.io/collabora/code:latest";
        autoUpdate = "registry";
        network = [
          "nextcloud-net"
          "proxy-net"
        ];
        ports = [
          "9980:9980"
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
}
