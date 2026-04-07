#!/usr/bin/env nix-shell
#!nix-shell -i python3  -p "python3.withPackages(ps: with ps; [ typer rich ])"
import os
import sys
import subprocess
import socket
import getpass
import shutil

REPO_URL = "https://github.com/Cian-H/My_NixOS_Config"
TARGET_DIR = os.path.expanduser("~/.config/nix")


def command_exists(cmd: str) -> bool:
    """Check if a command is available on the system."""
    return shutil.which(cmd) is not None


def check_preconditions(target_dir: str):
    """Ensure the system is in a valid state to begin bootstrapping."""
    if not command_exists("git"):
        print(
            "Error: 'git' is not installed. Please install git before bootstrapping.",
            file=sys.stderr,
        )
        sys.exit(1)

    if os.path.exists(target_dir):
        print(
            f"Error: {target_dir} already exists. Aborting bootstrap.", file=sys.stderr
        )
        sys.exit(1)


def clone_repository(repo_url: str, target_dir: str):
    """Clone the configuration repository and enter the directory."""
    print(f">> Cloning {repo_url} into {target_dir}...")
    try:
        subprocess.run(["git", "clone", repo_url, target_dir], check=True)
    except subprocess.CalledProcessError:
        print("Error: Failed to clone repository.", file=sys.stderr)
        sys.exit(1)

    os.chdir(target_dir)


def detect_nixos() -> bool:
    """Check if the current host system is NixOS."""
    if os.path.exists("/etc/os-release"):
        with open("/etc/os-release", "r") as f:
            if "ID=nixos" in f.read():
                return True
    return False


def has_config(sys_name: str, is_nixos: bool) -> bool:
    """Determine if system configuration directories exist for the given hostname."""
    has_nixos_dir = os.path.isdir(f"nixos/{sys_name}")
    has_hm_dir = os.path.isdir(f"home-manager/{sys_name}")
    return (has_nixos_dir and has_hm_dir) if is_nixos else has_hm_dir


def get_available_systems() -> list:
    """Discover existing system configurations in the repository."""
    opts = set()
    if os.path.exists("nixos"):
        opts.update([d for d in os.listdir("nixos") if os.path.isdir(f"nixos/{d}")])
    if os.path.exists("home-manager"):
        opts.update(
            [
                d
                for d in os.listdir("home-manager")
                if os.path.isdir(f"home-manager/{d}")
            ]
        )

    # Filter out base/core directories and hidden folders, then sort for consistent output
    return sorted([o for o in opts if o not in ["core"] and not o.startswith(".")])


def setup_new_config(target_sys: str, target_dir: str, is_nixos: bool):
    """Create boilerplate directories for a missing system and open an editor."""
    print(">> Creating directories...")
    if is_nixos:
        os.makedirs(f"nixos/{target_sys}", exist_ok=True)
    os.makedirs(f"home-manager/{target_sys}", exist_ok=True)

    if command_exists("yazi"):
        print(">> Opening yazi. Please add your configs and exit yazi when finished.")
        subprocess.run(["yazi", target_dir])
    else:
        print(
            f">> Yazi not found. Please manually configure your files in {target_dir} in another terminal."
        )
        input("Press Enter when you have finished adding your configurations...")


def prompt_for_existing_config(current_sys: str, current_user: str) -> tuple[str, str]:
    """Prompt the user to select an existing configuration from the repo."""
    opts = get_available_systems()
    if not opts:
        print(
            "Error: No existing configurations found. Cannot proceed.", file=sys.stderr
        )
        sys.exit(1)

    print("\nAvailable systems:")
    for o in opts:
        print(f"  - {o}")

    chosen_sys = input(f"\nEnter system to use [default: {current_sys}]: ").strip()
    if chosen_sys:
        if chosen_sys not in opts:
            print(f"Error: '{chosen_sys}' is not a valid option.")
            sys.exit(1)
        target_sys = chosen_sys
    else:
        target_sys = current_sys
        # Failsafe: if they press enter, but the default hostname isn't actually a valid config
        if target_sys not in opts:
            print(
                f"Error: Default '{target_sys}' is not in available systems. You must type a valid option."
            )
            sys.exit(1)

    chosen_user = input(
        f"Enter user configuration to use [default: {current_user}]: "
    ).strip()
    target_user = chosen_user if chosen_user else current_user

    return target_sys, target_user


def resolve_configuration(
    target_sys: str, target_user: str, target_dir: str, is_nixos: bool
) -> tuple[str, str]:
    """Ensure a valid configuration target exists, prompting the user for resolution if necessary."""
    if has_config(target_sys, is_nixos):
        return target_sys, target_user

    print(
        f"\n>> Configuration for system '{target_sys}' (user: '{target_user}') not found."
    )
    ans = (
        input("Do you want to create the missing directories now? [y/N]: ")
        .strip()
        .lower()
    )

    if ans == "y":
        setup_new_config(target_sys, target_dir, is_nixos)
        return target_sys, target_user

    ans = (
        input("Do you want to switch to one of the existing configs instead? [y/N]: ")
        .strip()
        .lower()
    )
    if ans == "y":
        return prompt_for_existing_config(target_sys, target_user)

    print(
        "Error: Cannot proceed without a valid configuration. Aborting.",
        file=sys.stderr,
    )
    sys.exit(1)


def execute_installation(target_sys: str, target_user: str, is_nixos: bool):
    """Execute the final NixOS or Home Manager commands to build the system."""
    print(
        f"\n>> Proceeding with installation for user '{target_user}' on system '{target_sys}'..."
    )
    try:
        if is_nixos:
            print(
                ">> [NixOS detected] Performing full system and home-manager install..."
            )
            subprocess.run(
                ["sudo", "nixos-rebuild", "switch", "--flake", f".#{target_sys}"],
                check=True,
            )
            subprocess.run(
                ["home-manager", "switch", "--flake", f".#{target_user}@{target_sys}"],
                check=True,
            )
        else:
            print(">> [Non-NixOS detected] Performing home-manager install only...")
            subprocess.run(
                ["home-manager", "switch", "--flake", f".#{target_user}@{target_sys}"],
                check=True,
            )
        print("\n>> Bootstrap complete! Welcome to your new environment.")
    except subprocess.CalledProcessError as e:
        print(f"\nError: Command '{' '.join(e.cmd)}' failed with exit status {e.returncode}.", file=sys.stderr)
        sys.exit(e.returncode)


def main():
    """Main orchestration loop."""
    check_preconditions(TARGET_DIR)
    clone_repository(REPO_URL, TARGET_DIR)

    is_nixos = detect_nixos()
    hostname = socket.gethostname()
    username = getpass.getuser()

    # The returned tuple contains the final resolved system/user strings
    final_sys, final_user = resolve_configuration(
        hostname, username, TARGET_DIR, is_nixos
    )

    execute_installation(final_sys, final_user, is_nixos)


if __name__ == "__main__":
    main()
