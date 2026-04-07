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

quick-update-root:
    just git=false flake=false update-root

quick-update-home:
    just git=false flake=false update-home

quick-update:
    just git=false flake=false update

nogit-update-root:
    just git=false update-root

nogit-update-home:
    just git=false update-home

nogit-update:
    just git=false update

noflake-update-root:
    just flake=false update-root

noflake-update-home:
    just flake=false update-home

noflake-update:
    just flake=false update

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

edit target:
    #!/usr/bin/env python3
    import os
    import subprocess
    import sys

    target = "{{target}}"

    # If it doesn't exist, assume we are creating a new text file
    if not os.path.exists(target):
        subprocess.run(["nvim", target])
        sys.exit(0)

    # If it's a directory, use yazi
    if os.path.isdir(target):
        subprocess.run(["yazi", target])
    else:
        # Check if the file is text or binary by attempting to read it
        is_text = True
        try:
            with open(target, 'tr', encoding='utf-8') as check_file:
                check_file.read(1024)
        except UnicodeDecodeError:
            is_text = False

        if is_text:
            subprocess.run(["nvim", target])
        else:
            subprocess.run(["heh", target])

# Opens the relevant packages.nix file for editing.
# Flags:
#   --home        : Edit home-manager config instead of NixOS config
#   --sys <name>  : Specify system (defaults to current hostname)
#   --user <name> : Specify user (defaults to current user, only relevant if --home is passed)
#   --no-update   : Skip the auto-update after editing
packages *flags:
    #!/usr/bin/env bash
    set -e

    # Inject 'just' parameters into the bash script's positional arguments
    eval set -- "{{flags}}"

    HOME_FLAG=false
    SYS="$(hostname)"
    USER_VAL="$(whoami)"
    UPDATE_FLAG=true

    # Parse command line flags
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help|help|-h)
                echo "Usage: just packages [OPTIONS]"
                echo ""
                echo "Opens the packages.nix file for editing and optionally updates."
                echo ""
                echo "Options:"
                echo "  home, --home             Edit home-manager config instead of NixOS config"
                echo "  sys, --sys <name>        Specify system (defaults to current hostname: $(hostname))"
                echo "  user, --user <name>      Specify user (defaults to current user: $(whoami))"
                echo "  update, --update         Run auto-update after editing (Default)"
                echo "  no-update, --no-update   Skip the auto-update after editing"
                echo "  help, --help, -h         Show this help message"
                echo ""
                echo "Examples:"
                echo "  just packages home                      (Edits HM for current system/user)"
                echo "  just packages sys homeserver no-update  (Edits NixOS on homeserver, skips update)"
                exit 0
                ;;
            --home|home)
                HOME_FLAG=true
                shift
                ;;
            --sys|sys)
                SYS="$2"
                shift 2
                ;;
            --user|user)
                USER_VAL="$2"
                shift 2
                ;;
            --no-update|no-update)
                UPDATE_FLAG=false
                shift
                ;;
            --update|update)
                UPDATE_FLAG=true
                shift
                ;;
            *)
                echo "Unknown option: $1"
                echo "Run 'just packages help' for valid options."
                exit 1
                ;;
        esac
    done

    # Determine the target path
    if [ "$HOME_FLAG" = "true" ]; then
        TARGET="home-manager/$SYS/packages.nix"
    else
        TARGET="nixos/$SYS/packages.nix"
    fi

    echo ">> Editing $TARGET..."
    just edit "$TARGET"

    if [ "$UPDATE_FLAG" = "true" ]; then
        echo ">> Applying updates..."
        just quick-update
    else
        echo ">> Skipping update (no-update provided)."
    fi

# Bootstraps a system from scratch. Clones the repo and installs configs based on OS.
bootstrap:
    #!/usr/bin/env python3
    import os
    import sys
    import subprocess
    import socket
    import getpass
    from pathlib import Path

    REPO_URL = "https://github.com/Cian-H/My_NixOS_Config"
    TARGET_DIR = os.path.expanduser("~/.config/nix")

    # Prevent running if directory already exists
    if os.path.exists(TARGET_DIR):
        print(f"Error: {TARGET_DIR} already exists. Aborting bootstrap.", file=sys.stderr)
        sys.exit(1)

    # Clone the repository
    print(f">> Cloning {REPO_URL} into {TARGET_DIR}...")
    try:
        subprocess.run(["git", "clone", REPO_URL, TARGET_DIR], check=True)
    except subprocess.CalledProcessError:
        print("Error: Failed to clone repository.", file=sys.stderr)
        sys.exit(1)

    # Change to the newly cloned repo directory for remaining commands
    os.chdir(TARGET_DIR)

    # OS Detection
    is_nixos = False
    if os.path.exists("/etc/os-release"):
        with open("/etc/os-release", "r") as f:
            if "ID=nixos" in f.read():
                is_nixos = True

    target_sys = socket.gethostname()
    target_user = getpass.getuser()

    # Determine if system configuration directories exist
    def config_exists(sys_name):
        has_nixos = os.path.isdir(f"nixos/{sys_name}")
        has_hm = os.path.isdir(f"home-manager/{sys_name}")
        return (has_nixos and has_hm) if is_nixos else has_hm

    # Handle Missing Configurations
    if not config_exists(target_sys):
        print(f"\n>> Configuration for system '{target_sys}' (user: '{target_user}') not found.")
        ans = input("Do you want to create the missing directories now? [y/N]: ").strip().lower()

        if ans == 'y':
            print(">> Creating directories...")
            if is_nixos:
                os.makedirs(f"nixos/{target_sys}", exist_ok=True)
            os.makedirs(f"home-manager/{target_sys}", exist_ok=True)

            print(">> Opening yazi. Please add your configs and exit yazi when finished.")
            subprocess.run(["yazi", TARGET_DIR])
        else:
            ans = input("Do you want to switch to one of the existing configs instead? [y/N]: ").strip().lower()
            if ans == 'y':
                # Gather available options
                opts = set()
                if os.path.exists("nixos"):
                    opts.update([d for d in os.listdir("nixos") if os.path.isdir(f"nixos/{d}")])
                if os.path.exists("home-manager"):
                    opts.update([d for d in os.listdir("home-manager") if os.path.isdir(f"home-manager/{d}")])

                # Filter out base/core directories
                opts = [o for o in opts if o not in ["core"] and not o.startswith(".")]

                print("\nAvailable systems:")
                for o in opts:
                    print(f"  - {o}")

                # Option selection for missing parameters
                chosen_sys = input(f"\nEnter system to use [default: {target_sys}]: ").strip()
                if chosen_sys:
                    if chosen_sys not in opts:
                        print(f"Error: '{chosen_sys}' is not a valid option.")
                        sys.exit(1)
                    target_sys = chosen_sys

                chosen_user = input(f"Enter user configuration to use [default: {target_user}]: ").strip()
                if chosen_user:
                    target_user = chosen_user

            else:
                print("Error: Cannot proceed without a valid configuration. Aborting.", file=sys.stderr)
                sys.exit(1)

    print(f"\n>> Proceeding with installation for user '{target_user}' on system '{target_sys}'...")

    # Execute Installations
    try:
        if is_nixos:
            print(">> [NixOS detected] Performing full system and home-manager install...")
            subprocess.run(["sudo", "nixos-rebuild", "switch", "--flake", f".#{target_sys}"], check=True)
            subprocess.run(["home-manager", "switch", "--flake", f".#{target_user}@{target_sys}"], check=True)
        else:
            print(">> [Non-NixOS detected] Performing home-manager install only...")
            subprocess.run(["home-manager", "switch", "--flake", f".#{target_user}@{target_sys}"], check=True)
        print("\n>> Bootstrap complete! Welcome to your new environment.")
    except subprocess.CalledProcessError:
        print("\nError: An issue occurred during installation.", file=sys.stderr)
        sys.exit(1)
