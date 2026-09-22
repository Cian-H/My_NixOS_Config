{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  sops.secrets = {
    homepage_nextcloud_username = {};
    homepage_nextcloud_password = {};
    homepage_gitea_token = {};
    homepage_jellyfin_apikey = {};
    homepage_freshrss_username = {};
    homepage_freshrss_password = {};
    homepage_vikunja_token = {};
  };

  # Rendered env file with widget credentials — secrets are interpolated at activation time
  sops.templates."homepage.env" = {
    content = ''
      HOMEPAGE_VAR_NEXTCLOUD_USERNAME=${config.sops.placeholder.homepage_nextcloud_username}
      HOMEPAGE_VAR_NEXTCLOUD_PASSWORD=${config.sops.placeholder.homepage_nextcloud_password}
      HOMEPAGE_VAR_GITEA_TOKEN=${config.sops.placeholder.homepage_gitea_token}
      HOMEPAGE_VAR_JELLYFIN_APIKEY=${config.sops.placeholder.homepage_jellyfin_apikey}
      HOMEPAGE_VAR_FRESHRSS_USERNAME=${config.sops.placeholder.homepage_freshrss_username}
      HOMEPAGE_VAR_FRESHRSS_PASSWORD=${config.sops.placeholder.homepage_freshrss_password}
      HOMEPAGE_VAR_VIKUNJA_TOKEN=${config.sops.placeholder.homepage_vikunja_token}
    '';
  };

  services.podman.containers = {
    homepage = {
      image = "ghcr.io/gethomepage/homepage:latest";
      autoUpdate = "registry";
      network = [ "proxy-net" ];
      environment = {
        HOMEPAGE_ALLOWED_HOSTS = "home.bulba.space,homepage:3000,localhost:3000";
      };
      volumes = [
        # Config files — all read-only from the Nix store
        "${./homepage/services.yaml}:/app/config/services.yaml:ro"
        "${./homepage/settings.yaml}:/app/config/settings.yaml:ro"
        "${./homepage/widgets.yaml}:/app/config/widgets.yaml:ro"
        "${./homepage/bookmarks.yaml}:/app/config/bookmarks.yaml:ro"
        "${./homepage/docker.yaml}:/app/config/docker.yaml:ro"
        "${./homepage/custom.css}:/app/config/custom.css:ro"
        # Podman socket for container status integration
        "/run/user/1000/podman/podman.sock:/var/run/docker.sock:z"
      ];
      extraConfig = {
        Container = {
          EnvironmentFile = [ config.sops.templates."homepage.env".path ];
        };
      };
    };
  };
}
