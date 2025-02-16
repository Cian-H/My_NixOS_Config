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
        ports = [
          "9000:9000"
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
    };
  };
}
