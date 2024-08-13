{ inputs
, lib
, config
, pkgs
, unstablePkgs
, ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ]; # or "nvidiaLegacy470 etc.

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.nvidia-container-toolkit.enable = true;

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.efi.canTouchEfiVariables = true;
  # Enable hibernation
  boot.resumeDevice = "/dev/disk/by-uuid/526c41a3-66ec-4c6e-ad28-a32dfa99933e";

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

  # Add each flake input as a registry
  # This makes nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add the inputs to the system's legacy channels
  # Making legacy nix commands consistent as well
  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc =
    lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = false;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "ie";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "ie";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  users.users.cianh = {
    isNormalUser = true;
    hashedPasswordFile = "/etc/hashedPasswordFile";
    description = "Cian Hughes";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [
    # shell env programs
    atuin
    bat
    bottom
    du-dust
    duf
    fastfetch
    fd
    fzf
    gh
    git
    git-extras
    glab
    grub2_efi
    gvfs
    jq
    killall
    less
    mosh
    netcat-gnu
    nix-index
    nix-ld
    nmap
    nodejs_22
    nushell
    onefetch
    podman-compose
    powertop
    qmk
    qmk_hid
    qmk-udev-rules
    ranger
    ripgrep
    tealdeer
    unzip
    vial
    xcp
    xfce.thunar
    xfce.tumbler
    xfce.xfconf
    zoxide
    # package managers
    flatpak
    # fonts
    corefonts
    liberation_ttf
    monaspace
    nerdfonts
    nerd-font-patcher
    noto-fonts
    noto-fonts-color-emoji
    vistafonts
    winePackages.fonts
    # front-end dev environment
    kitty
    micro
  ]) ++ (with unstablePkgs; [
    neovim
    # alternative DEs and accompanying tools
    hyprcursor
    hyprland
    hyprpaper
    iwgtk
    libnotify
    qt6ct
    swaylock
    swaynotificationcenter
    waybar
    wofi
    xdg-desktop-portal-hyprland
  ]);

  hardware.keyboard.qmk.enable = true;

  # Activate alternative DEs
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # enableNvidiaPatches = true; # <- no longer necessary, apparently
  };

  # Enable my preferred DE utilities
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-volman
    thunar-archive-plugin
    thunar-media-tags-plugin
  ];
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  programs.xfconf.enable = true;

  # Lets also activate some handy devenv tools
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.nix-ld.enable = true;

  # Enable flatpaks
  services.flatpak.enable = true;

  # Enable the OpenSSH daemon and other remote tools.
  services.openssh.enable = true;
  programs.mosh.enable = true;

  virtualisation = {
    containers.enable = true;

    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  system.stateVersion = "23.11"; # Did you read the comment?
  system.autoUpgrade.enable = true;

  # Set user config settings
  users.defaultUserShell = pkgs.nushell;
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    fontconfig = {
      defaultFonts = {
        serif = [ "NotoSerifNerdFont" ];
        sansSerif = [ "NotoSansNerdFont" ];
        monospace = [ "MonaspiceArNerdFontMono" ];
      };
    };
  };
}
