default:
    @just --list

prebuild:
    git pull --recurse
    git submodule update --remote --recursive
    nix flake update

_update-root:
    if `/usr/bin/env grep -Rq "nixos" /etc/*-release`; then \
        sudo nixos-rebuild switch --flake .?submodules=1#$HOSTNAME; \
    fi

update-root: prebuild _update-root

install-home:
    home-manager switch --flake .?submodules=1#$USER@core \
        --extra-experimental-features nix-command \
        --extra-experimental-features flakes

_update-home:
    home-manager switch --flake .?submodules=1#$USER@$HOSTNAME \
    || home-manager switch --flake .?submodules=1#$USER@core

update-home: prebuild _update-home

update: prebuild _update-root _update-home

cleanup:
    nix-store --gc
    nix-store --optimise
