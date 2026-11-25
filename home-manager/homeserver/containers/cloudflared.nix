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
    cloudflared = {
      image = "docker.io/cloudflare/cloudflared:latest";
      autoUpdate = "registry";
      network = "proxy-net";
      exec = "tunnel --no-autoupdate run";
      extraConfig = {
        Container = {
          EnvironmentFile = [ config.sops.templates."cloudflare.env".path ];
        };
      };
    };
  };
}
