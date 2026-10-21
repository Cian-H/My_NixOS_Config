{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: let
  gickupConf = pkgs.writeText "gickup-conf.yml" ''
    # 1. GitHub -> GitLab & Forgejo
    cron: "0 0 * * *"
    source:
      github:
        - token: GITHUB_TOKEN
          includeorgs:
            - Cian-H
          wiki: true
    destination:
      gitlab:
        - token: GITLAB_TOKEN
          mirror:
            enabled: true
      gitea:
        - url: http://forgejo:3000
          token: FORGEJO_TOKEN
          user: Cian-H
          lfs: true
          mirror:
            enabled: true
    ---
    # 2. GitLab -> GitHub & Forgejo
    source:
      gitlab:
        - token: GITLAB_TOKEN
          user: Cian-H
          includeorgs:
            - Cian-H
          wiki: true
    destination:
      github:
        - token: GITHUB_TOKEN
      gitea:
        - url: http://forgejo:3000
          token: FORGEJO_TOKEN
          user: Cian-H
          lfs: true
          mirror:
            enabled: true
    ---
    # 3. Forgejo -> GitHub & GitLab
    source:
      gitea:
        - url: http://forgejo:3000
          token: FORGEJO_TOKEN
          user: Cian-H
          includeorgs:
            - Cian-H
          wiki: true
    destination:
      github:
        - token: GITHUB_TOKEN
      gitlab:
        - token: GITLAB_TOKEN
          mirror:
            enabled: true
  '';
in {
  sops.secrets = {
    gickup_github_token = {};
    gickup_gitlab_token = {};
    gickup_forgejo_token = {};
  };

  sops.templates."gickup.env" = {
    content = ''
      GITHUB_TOKEN=${config.sops.placeholder.gickup_github_token}
      GITLAB_TOKEN=${config.sops.placeholder.gickup_gitlab_token}
      FORGEJO_TOKEN=${config.sops.placeholder.gickup_forgejo_token}
    '';
  };

  services.podman = {
    networks = {
      forgejo-net = {};
    };
    containers = {
      forgejo = {
        image = "codeberg.org/forgejo/forgejo:17";
        autoUpdate = "registry";
        network = [
          "forgejo-net"
          "proxy-net"
        ];
        environment = {
          TZ = "Europe/Dublin";
        };
        volumes = [
          "/home/cianh/forgejo:/data"
          "/etc/localtime:/etc/localtime:ro"
        ];
      };

      gickup = {
        image = "ghcr.io/cooperspencer/gickup:latest";
        autoUpdate = "registry";
        network = [
          "forgejo-net"
        ];
        environment = {
          TZ = "Europe/Dublin";
        };
        volumes = [
          "${gickupConf}:/gickup/conf.yml:ro"
          "/etc/localtime:/etc/localtime:ro"
        ];
        extraConfig = {
          Container = {
            EnvironmentFile = [config.sops.templates."gickup.env".path];
          };
          Unit = {
            After = ["podman-forgejo.service"];
            Requires = ["podman-forgejo.service"];
          };
        };
      };
    };
  };
}
