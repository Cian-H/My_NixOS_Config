{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  imports = [
    ./core.nix
    ./homeserver/hardware-configuration.nix
    ./homeserver/packages.nix
    ./homeserver/programs.nix
    ./homeserver/services.nix
    ./homeserver/filesystems.nix
    ./homeserver/firewall.nix
    ./homeserver/virtualisation.nix
    ./homeserver/environment.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;

  networking.hostName = "homeserver"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Dublin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  nix = {
    registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 14d";
    };
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
    extraOptions = ''
      trusted-users = root cianh
    '';
  };

  system.activationScripts.linkRootJustfile = {
    text = ''
      ln -sf /etc/justfile /root/.justfile
      mkdir -p /root/.config/git
      ln -sf /etc/root_gitconfig /root/.config/git/config
    '';
    deps = [];
  };

  # Configure console keymap
  console.keyMap = "uk";

  users.users = {
    cianh = {
      isNormalUser = true;
      hashedPasswordFile = "/etc/hashedPasswordFile";
      description = "Cian Hughes";
      extraGroups = ["networkmanager" "wheel" "docker" "podman" "nixcfg"];
      shell = unstablePkgs.nushell;
      openssh.authorizedKeys.keyFiles = [
        ./homeserver/ssh/authorized_keys
      ];
    };

    root = {
      shell = pkgs.bashInteractive;
      openssh.authorizedKeys.keyFiles = [
        ./homeserver/ssh/authorized_keys
      ];
      extraGroups = ["docker" "podman" "nixcfg"];
    };
  };

  system = {
    stateVersion = "24.11"; # Did you read the comment?
    autoUpgrade.enable = true;
    autoUpgrade.dates = "weekly";
  };

  # Set user config settings
  users.defaultUserShell = pkgs.nushell;
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    fontconfig.defaultFonts.monospace = ["MonaspiceArNerdFontMono"];
    packages = [
      pkgs.nerd-fonts.monaspace
    ];
  };
}
