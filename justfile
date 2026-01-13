set shell := ["bash", "-c"]

git := "true"
flake := "true"
flatpak := "true"

default:
    @just --choose

_git-sync:
    git pull --recurse
    git submodule update --remote --recursive

_flake-update:
    nix flake update

prebuild:
    @if [ "{{git}}" == "true" ]; then \
        echo ">> Syncing Git..."; \
        just _git-sync; \
    fi
    @if [ "{{flake}}" == "true" ]; then \
        echo ">> Updating Flake..."; \
        just _flake-update; \
    fi

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

update-flatpaks:
    @if [ "{{flatpak}}" == "true" ] && command -v flatpak &> /dev/null; then \
        echo ">> Updating Flatpaks..."; \
        flatpak update -y; \
        flatpak uninstall --unused -y; \
    else \
        echo ">> Flatpak not found or disabled. Skipping."; \
    fi

history:
    @echo ">> System Generations:"
    @nix-env -p /nix/var/nix/profiles/system --list-generations | tail -n 5
    @echo "\n>> Home Manager Generations:"
    @home-manager generations | head -n 5

repl:
    nix repl --file flake.nix

update: prebuild _update-root _update-home update-flatpaks

cleanup days="":
    @if [ -n "{{days}}" ]; then \
        echo ">> Deleting system generations older than {{days}}..."; \
        sudo nix-collect-garbage --delete-older-than {{days}}; \
    fi
    @echo ">> Cleaning Nix Store..."
    nix-store --gc
    nix-store --optimise
    @if command -v flatpak &> /dev/null; then \
        echo ">> Cleaning unused Flatpaks..."; \
        flatpak uninstall --unused -y; \
    fi
