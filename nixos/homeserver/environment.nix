{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry
    // {
      "justfile" = {
        text = ''
          default:
              @just -g --list

          update-root:
              if `/usr/bin/env grep -Rq "nixos" /etc/*-release`; then \
                  nixos-rebuild switch --flake /home/cianh/.config/nix/#$HOSTNAME; \
              fi
        '';
        mode = "0644";
      };
      "root_gitconfig" = {
        text = ''
          [safe]
              directory = /home/cianh/.config/nix
        '';
      };
    };
  environment.systemPackages = [
    pkgs.pinentry-tty
  ];
}
