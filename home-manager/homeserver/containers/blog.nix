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
      blog-net = {};
    };
    containers = {
      ghost = {
        image = "docker.io/library/ghost:alpine";
        autoUpdate = "registry";
        network = [
          "blog-net"
          "proxy-net"
        ];
        environment = {
          database__client = "mysql";
          database__connection__host = "ghost-db";
          database__connection__user = "root";
          database__connection__password = config.sops.secrets.ghost_dbpassword.path;
          database__connection__database = "ghost";
          url = "https://blog.bulba.space";
        };
        volumes = [
          "/home/cianh/blog/content:/var/lib/ghost/content"
        ];
      };
      ghost-db = {
        image = "docker.io/library/mysql:8.0";
        autoUpdate = "registry";
        network = "blog-net";
        environment = {
          MYSQL_ROOT_PASSWORD = config.sops.secrets.ghost_dbpassword.path;
        };
        volumes = [
          "/home/cianh/blog/db:/var/lib/mysql"
        ];
      };
    };
  };

  home.file."caddy/config/subdomains/blog.caddyfile".source = ./caddy_config/subdomains/blog.caddyfile;
}
