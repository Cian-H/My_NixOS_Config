set shell := ["bash", "-c"]

git := "true"
flake := "true"
flatpak := "true"

# Show this interactive menu
default:
    @just --choose

_git-sync:
    @if [ -n "$(git status --porcelain)" ]; then \
        echo ">> Error: Git working directory is not clean. Stash or commit your changes first."; \
        exit 1; \
    fi
    git pull --ff-only --recurse-submodules
    git submodule update --remote --recursive

_flake-update:
    nix flake update

# Sync git and update flake inputs (override with git=false or flake=false)
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
    @if [ -f /etc/NIXOS ] && grep -q "nixos" /etc/os-release 2>/dev/null; then \
        sudo nixos-rebuild switch --flake .?submodules=1#$(hostname); \
    fi

# Rebuild and switch NixOS system configuration
update-root: prebuild _update-root

# Install Home Manager standalone (useful for initial non-NixOS setup)
install-home:
    home-manager switch --flake .?submodules=1#$(whoami)@core \
        --extra-experimental-features nix-command \
        --extra-experimental-features flakes

_update-home:
    home-manager switch --flake .?submodules=1#$(whoami)@$(hostname) \
    || home-manager switch --flake .?submodules=1#$(whoami)@core

# Rebuild and switch Home Manager configuration
update-home: prebuild _update-home

# Quick update skipping git and flake syncs
quick-update:
    just git=false flake=false update

# Update the system without fetching the latest git commits
nogit-update:
    just git=false update

# Update and clean up Flatpak packages
update-flatpaks:
    @if [ "{{flatpak}}" == "true" ] && command -v flatpak &> /dev/null; then \
        echo ">> Updating Flatpaks..."; \
        flatpak update -y; \
        flatpak uninstall --unused -y; \
    else \
        echo ">> Flatpak not found or disabled. Skipping."; \
    fi

# View the 5 most recent NixOS and Home Manager generations
history:
    @echo ">> System Generations:"
    @nix-env -p /nix/var/nix/profiles/system --list-generations | tail -n 5
    @echo "\n>> Home Manager Generations:"
    @home-manager generations | head -n 5

# Open a Nix REPL loaded with the current flake
repl:
    nix repl --file flake.nix

# Fully update the system, home-manager, and flatpaks
update: prebuild _update-root _update-home update-flatpaks

# Run Nix and Flatpak garbage collection. Optionally specify age (e.g., 'just cleanup 7d')
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

# Open the editor (nvim, yazi, or heh) for a target
edit target:
    @direnv exec . scripts/edit.py "{{target}}"

# Edit packages.nix for a specific system/user (run 'just packages help' for flags)
packages *flags:
    @direnv exec . scripts/packages.bb {{flags}}

# Bootstrap a fresh system from the repo
bootstrap:
    @direnv exec . scripts/bootstrap.py
