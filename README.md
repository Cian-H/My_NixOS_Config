# **My NixOS Configuration ❄️**

This repository contains my personal declarative configuration for NixOS systems and Home Manager profiles. It uses **Nix Flakes** for reproducibility and dependency management.

## **🖥️ Hosts**

| Hostname | Type | Description | Key Features |
| :---- | :---- | :---- | :---- |
| **worklaptop** | Laptop | Personal workstation | Hyprland (UWSM), Nvidia Prime, Dev Tools, Gaming |
| **homeserver** | Server | Headless Homelab | Podman Containers, Caddy Reverse Proxy, Gitea, Nextcloud |
| **core** | Profile | Generic Home Manager config | Base CLI tools, Shell config, Dotfiles (Distro-agnostic) |

## **✨ Features**

* **Flakes:** Fully flake-enabled configuration.  
* **Shell:** [Nushell](https://www.nushell.sh/) configured as the default user shell with carapace and starship integration.  
* **Core Profile:** A core configuration is available for bootstrapping new machines or for use on non-NixOS Linux distributions, providing a consistent shell and CLI environment without system-level dependencies.  
* **Window Manager:** Hyprland with uwsm (Universal Wayland Session Manager) on the laptop.  
* **Secrets:** [Sops-nix](https://github.com/Mic92/sops-nix) implementation using Age encryption for managing sensitive data (API keys, database passwords).  
* **Containers:** Declarative OCI containers using Podman (replacing Docker) for homeserver services.  
* **Automation:** A justfile is included to simplify system updates and garbage collection.  
* **Theming:** Centralized TokyoNight theme definition passed as specialArgs to Home Manager modules.  
* **Dotfiles:** Dotfiles are managed via a git submodule mapped to home-manager/core/dotfiles.

## **📂 Structure**

.  
├── .github/             \# GitHub Actions (Submodule sync)  
├── flake.nix            \# Entrypoint & Input definitions  
├── flake.lock           \# Pinned dependency versions  
├── justfile             \# Command runner for system maintenance  
├── nixos/               \# System-level configurations  
│   ├── core/            \# Shared system modules  
│   ├── homeserver/      \# Server-specific hardware & services  
│   └── worklaptop/      \# Laptop-specific hardware & services  
├── home-manager/        \# User-level configurations  
│   ├── core/            \# Shared user modules (dotfiles, shell, etc.)  
│   ├── homeserver/      \# Server user config  
│   └── worklaptop/      \# Laptop user config (Hyprland, Theming)  
└── secrets.yaml         \# Encrypted secrets (SOPS)

## **🚀 Bootstrap / Installation**

1. **Clone the repository:**  
   git clone \--recursive \[https://github.com/Cian-H/my\_nixos\_config.git\](https://github.com/Cian-H/my\_nixos\_config.git) /home/cianh/my\_nixos\_config  
   cd my\_nixos\_config

2. **Setup Secrets:**  
   Place your Age private key in the appropriate location (defined in home-manager/\<host\>.nix):  
   * Target: \~/.config/sops/age/keys.txt  
3. **Apply Configuration:**  
   * **NixOS System:**  
     sudo nixos-rebuild switch \--flake .\#\<hostname\>

   * **Home Manager (Specific Host):**  
     home-manager switch \--flake .\#cianh@\<hostname\>

   * **Home Manager (Core/Generic):**  
     home-manager switch \--flake .\#cianh@core

## **🛠️ Management (Justfile)**

I use just to abstract away common nixos-rebuild and home-manager commands.

| Command | Description |
| :---- | :---- |
| just update | Updates both System and Home Manager (pulls git & updates flake). |
| just update-root | Updates only the NixOS system configuration. |
| just update-home | Updates only the Home Manager configuration. |
| just install-home | Installs the generic core Home Manager profile. |
| just quick-update | Rebuilds configuration *without* pulling git or updating flake inputs. |
| just cleanup \<days\> | Garbage collects generations older than \<days\> and optimizes store. |
| just repl | Opens a Nix REPL loaded with the flake context. |

**Example:**

\# Full system update  
just update

\# Quick rebuild after changing a config file  
just quick-update

## **🔒 Secrets Management**

Secrets are managed via sops-nix.

* **Config:** .sops.yaml  
* **Key:** keys.txt (Age key)

To edit secrets:

sops home-manager/secrets.yaml

## **📦 Server Services (Homeserver)**

The homeserver runs services via Podman, orchestrated in home-manager/homeserver/containers.nix.

Key services include:

* **Proxy:** Caddy  
* **Cloud:** Nextcloud (with Redis & MariaDB)  
* **Code:** Gitea  
* **Productivity:** Vikunja  
* **Media:** Jellyfin

## **🔗 Submodules**

This repo uses a submodule for raw dotfiles.

* **Path:** home-manager/core/dotfiles  
* **Source:** https://github.com/Cian-H/dotfiles.git

If the folder is empty, initialize it:

git submodule update \--init \--recursive

