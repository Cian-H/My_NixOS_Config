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
    ./worklaptop/hardware-configuration.nix
    ./worklaptop/packages.nix
    ./worklaptop/programs.nix
    ./worklaptop/services.nix
    ./worklaptop/virtualisation.nix
    ./worklaptop/environment.nix
    ./worklaptop/theming.nix
  ];

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
  };

  hardware = {
    keyboard.qmk.enable = true;
    bluetooth.enable = true;
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [
        pkgs.intel-compute-runtime
        pkgs.intel-media-driver
        pkgs.libglvnd
        pkgs.libvdpau-va-gl
        pkgs.mesa
        pkgs.nvidia-vaapi-driver
        pkgs.vaapiIntel
        pkgs.vaapiVdpau
      ];
    };
    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    nvidia-container-toolkit.enable = true;
  };

  # Bootloader.
  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
      };
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = true;
      };
    };
    blacklistedKernelModules = ["nouveau"];
  };

  networking.hostName = "worklaptop"; # Define your hostname.

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

  # Configure console keymap
  console.keyMap = "ie";

  security.rtkit.enable = true;

  users.users.cianh = {
    isNormalUser = true;
    hashedPasswordFile = "/etc/hashedPasswordFile";
    description = "Cian Hughes";
    extraGroups = ["networkmanager" "wheel" "libvirtd"];
    shell = unstablePkgs.nushell;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-xapp
    ];
  };

  system = {
    stateVersion = "23.11"; # Did you read the comment?
    autoUpgrade.enable = true;
    autoUpgrade.dates = "weekly";
  };

  # Set user config settings
  users.defaultUserShell = pkgs.nushell;
}
