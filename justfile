default:
    @just --list

prebuild:
    git add .
    nix flake update

_update-root:
    if `/usr/bin/env grep -Rq "nixos" /etc/*-release`; then \
        sudo nixos-rebuild switch --flake .#$HOSTNAME; \
    fi

update-root: prebuild _update-root

_update-home:
    home-manager switch --flake .#$USER@$HOSTNAME

update-home: prebuild _update-home

update: prebuild _update-root _update-home

cleanup:
    nix-store --gc
    nix-store --optimise
