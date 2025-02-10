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
      nextcloud-aio-nextcloud = {
        image = "docker.io/nextcloud/aio-nextcloud:latest";
        autoUpdate = "registry";
        network = "nextcloud-net";
        extraPodmanArgs = [
          "/usr/bin/supervisord"
          "-c"
          "/supervisord.conf"
        ];
        env = {
          ADDITIONAL_APKS = "imagemagick";
          ADDITIONAL_PHP_EXTENSIONS = "imagick";
          ADMIN_PASSWORD = config.sops.secrets.nextcloud_admin_password;
          ADMIN_USER = "admin";
          AIO_TOKEN = config.sops.secrets.nextcloud_aio_token;
          AIO_URL = "192.168.0.254:8081";
          APACHE_HOST = "nextcloud-aio-apache";
          APACHE_PORT = "11000";
          CLAMAV_ENABLED = "yes";
          CLAMAV_HOST = "nextcloud-aio-clamav";
          CLAMAV_MAX_SIZE = "17179869184";
          COLLABORA_ENABLED = "yes";
          COLLABORA_HOST = "nextcloud-aio-collabora";
          FULLTEXTSEARCH_ENABLED = "yes";
          FULLTEXTSEARCH_HOST = "nextcloud-aio-fulltextsearch";
          FULLTEXTSEARCH_PASSWORD = config.sops.secrets.nextcloud_fulltextsearch_password;
          IMAGINARY_ENABLED = "yes";
          IMAGINARY_HOST = "nextcloud-aio-imaginary";
          IMAGINARY_SECRET = config.sops.secrets.nextcloud_imaginary_secret;
          NC_DOMAIN = "nextcloud.bulba.space";
          NEXTCLOUD_DATA_DIR = "/mnt/ncdata";
          NEXTCLOUD_EXEC_COMMANDS = "php /var/www/html/occ richdocuments:activate-config";
          NEXTCLOUD_HOST = "nextcloud-aio-nextcloud";
          ONLYOFFICE_HOST = "nextcloud-aio-onlyoffice";
          ONLYOFFICE_SECRET = config.sops.secrets.nextcloud_onlyoffice_secret;
          OVERWRITEHOST = "nextcloud.bulba.space";
          OVERWRITEPROTOCOL = "https";
          POSTGRES_DB = "nextcloud_database";
          POSTGRES_HOST = "nextcloud-aio-database";
          POSTGRES_PASSWORD = config.sops.secrets.nextcloud_postgres_password;
          POSTGRES_PORT = "5432";
          POSTGRES_USER = "nextcloud";
          RECORDING_SECRET = config.sops.secrets.nextcloud_recording_secret;
          REDIS_HOST = "nextcloud-aio-redis";
          REDIS_HOST_PASSWORD = config.sops.secrets.nextcloud_redis_host_password;
          REMOVE_DISABLED_APPS = "yes";
          SIGNALING_SECRET = config.sops.secrets.nextcloud_signaling_secret;
          STARTUP_APPS = "deck twofactor_totp tasks calendar contacts notes";
          TALK_PORT = "3478";
          TALK_RECORDING_HOST = "nextcloud-aio-talk-recording";
          THIS_IS_AIO = "true";
          TURN_SECRET = config.sops.secrets.nextcloud_turn_secret;
          TZ = "Europe/Dublin";
          WHITEBOARD_SECRET = config.sops.secrets.nextcloud_whiteboard_secret;
        };
        volumes = [
          "/home/cianh/Nextcloud/config/nextcloud_aio_nextcloud:/var/www/html"
          "/home/cianh/Nextcloud/data:/mnt/ncdata"
        ];
      };
      nextcloud-aio-collabora = {
        image = "docker.io/nextcloud/aio-collabora:latest";
        autoUpdate = "registry";
        network = "nextcloud-net";
        environment = {
          DONT_GEN_SSL_CERT = "1";
          aliasgroup1 = "https://nextcloud.bulba.space:443";
          dictionaries = "de_DE en_GB en_US es_ES fr_FR it nl pt_BR pt_PT ru";
          TZ = "Europe/Dublin";
          server_name = "nextcloud.bulba.space";
        };
        extraPodmanArgs = [
          "--o:ssl.enable=false"
          "--o:ssl.termination=true"
          "--o:mount_jail_tree=false"
          "--o:logging.level=warning"
          "--o:home_mode.enable=true"
          "--o:security.seccomp=true"
          "--o:remote_font_config.url=https://nextcloud.bulba.space/apps/richdocuments/settings/fonts.json"
          "--o:net.post_allow.host[0]=.+"
        ];
      };
      nextcloud-aio-database = {
        image = "docker.io/nextcloud/aio-postgresql:latest";
        autoUpdate = "registry";
        network = "nextcloud-net";
        env = {
          TZ = "Europe/Dublin";
          PGTZ = "Europe/Dublin";
          POSTGRES_PASSWORD = config.sops.secrets.nextcloud_postgres_password;
          POSTGRES_DB = "nextcloud_database";
          POSTGRES_USER = "nextcloud";
        };
        volumes = [
          "/home/cianh/Nextcloud/config/nextcloud_aio_database_dump:/mnt/data"
          "/home/cianh/Nextcloud/config/nextcloud_aio_database:/var/lib/postgresql/data"
        ];
      };
      nextcloud-aio-redis = {
        image = "docker.io/nextcloud/aio-redis:latest";
        autoUpdate = "registry";
        network = "nextcloud-net";
        env = {
          TZ = "Europe/Dublin";
          REDIS_HOST_PASSWORD = config.sops.secrets.nextcloud_redis_host_password;
        };
        volumes = [
          "/home/cianh/Nextcloud/config/nextcloud_aio_redis:/data"
        ];
      };
      nextcloud-aio-clamav = {
        image = "docker.io/nextcloud/aio-clamav:latest";
        autoUpdate = "registry";
        network = "nextcloud-net";
        env = {
          TZ = "Europe/Dublin";
          MAX_SIZE = "16G";
          CLAMD_STARTUP_TIMEOUT = "90";
        };
        volumes = [
          "/home/cianh/Nextcloud/config/nextcloud_aio_clamav:/var/lib/clamav"
        ];
      };
      nextcloud-aio-fulltextsearch = {
        image = "docker.io/nextcloud/aio-fulltextsearch:latest";
        autoUpdate = "registry";
        network = "nextcloud-net";
        extraPodmanArgs = [
          "eswrapper"
        ];
        env = {
          xpack.license.self_generated.type = "basic";
          discovery.type = "single-node";
          bootstrap.memory_lock = "true";
          xpack.security.enabled = "false";
          logger.org.elasticsearch.discovery = "WARN";
          http.port = "9200";
          TZ = "Europe/Dublin";
          FULLTEXTSEARCH_PASSWORD = config.sops.secrets.nextcloud_fulltextsearch_password;
          cluster.name = "nextcloud-aio";
          ES_JAVA_OPTS = "-Xms512M -Xmx512M";
        };
        volumes = [
          "/home/cianh/Nextcloud/config/nextcloud_aio_elasticsearch:/usr/share/elasticsearch/data"
        ];
      };
      nextcloud-aio-imaginary = {
        image = "docker.io/nextcloud/aio-imaginary:latest";
        autoUpdate = "registry";
        network = "nextcloud-net";
        env = {
          TZ = "Europe/Dublin";
          IMAGINARY_SECRET = config.sops.secrets.nextcloud_imaginary_secret;
        };
      };
      nextcloud-aio-notify-push = {
        image = "docker.io/nextcloud/aio-notify-push:latest";
        autoUpdate = "registry";
        network = "nextcloud-net";
        env = {
          NC_DOMAIN = "nextcloud.bulba.space";
          POSTGRES_DB = "nextcloud_database";
          POSTGRES_PORT = "5432";
          NEXTCLOUD_HOST = "nextcloud-aio-nextcloud";
          REDIS_HOST_PASSWORD = config.sops.secrets.nextcloud_redis_host_password;
          POSTGRES_USER = "nextcloud";
          REDIS_HOST = "nextcloud-aio-redis";
          POSTGRES_HOST = "nextcloud-aio-database";
          POSTGRES_PASSWORD = config.sops.secrets.nextcloud_postgres_password;
        };
        volumes = [
          "/home/cianh/Nextcloud/config/nextcloud_aio_nextcloud:/nextcloud:Z"
        ];
      };
      nextcloud-aio-apache = {
        image = "docker.io/nextcloud/aio-apache:latest";
        autoUpdate = "registry";
        network = [
          "nextcloud-net"
          "proxy-net"
        ];
        extraPodmanArgs = [
          "/usr/bin/supervisord"
          "-c"
          "/supervisord.conf"
        ];
        env = {
          APACHE_PORT = "11000";
          ONLYOFFICE_HOST = "nextcloud-aio-onlyoffice";
          APACHE_MAX_TIME = "3600";
          APACHE_HOST = "nextcloud-aio-apache";
          NOTIFY_PUSH_HOST = "nextcloud-aio-notify-push";
          NEXTCLOUD_HOST = "nextcloud-aio-nextcloud";
          TZ = "Europe/Dublin";
          APACHE_MAX_SIZE = "17179869184";
          TALK_HOST = "nextcloud-aio-talk";
          WHITEBOARD_HOST = "nextcloud-aio-whiteboard";
          COLLABORA_HOST = "nextcloud-aio-collabora";
          NC_DOMAIN = "nextcloud.bulba.space";
        };
        ports = [
          "11000:11000"
        ];
        volumes = [
          "/home/cianh/Nextcloud/config/nextcloud_aio_apache:/mnt/data"
          "/var/www/html:/var/www/html:Z"
        ];
      };
    };
  };
}
