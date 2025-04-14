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
    ./worklaptop/theming.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;

  boot.blacklistedKernelModules = ["nouveau"];
  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
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
  hardware.nvidia = {
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
  hardware.nvidia-container-toolkit.enable = true;
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
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

  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  # Load nvidia driver for Xorg and Wayland
  services = {
    xserver = {
      videoDrivers = ["nvidia"]; # or "nvidiaLegacy470 etc.
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = false;
      xkb = {
        layout = "ie";
        variant = "";
      };
    };
  };

  # Configure console keymap
  console.keyMap = "ie";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
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
    extraGroups = ["networkmanager" "wheel" "libvirtd"];
    shell = unstablePkgs.nushell;
  };
  # # The hack below sets the user profile image declaratively
  system.activationScripts.script.text = ''
    mkdir -p /var/lib/AccountsService/{icons,users}
    cp /home/cianh/Pictures/face.png /var/lib/AccountsService/icons/cianh
    echo "[User]
    Session=
    Icon=/var/lib/AccountsService/icons/cianh
    SystemAccount=false" > /var/lib/AccountsService/users/cianh
    chown root:root /var/lib/AccountsService/users/cianh
    chmod 0600 /var/lib/AccountsService/users/cianh
    chown root:root /var/lib/AccountsService/icons/cianh
    chmod 0444 /var/lib/AccountsService/icons/cianh
  '';

  # $ nix search wget
  environment.systemPackages = [
    # shell env programs
    pkgs.atuin
    pkgs.bat
    pkgs.bitwarden-cli
    pkgs.bottom
    pkgs.delta
    pkgs.du-dust
    pkgs.duf
    pkgs.fastfetch
    pkgs.fd
    pkgs.fzf
    pkgs.gdm
    pkgs.gh
    pkgs.git
    pkgs.git-extras
    pkgs.glab
    pkgs.glow
    pkgs.gnupg
    pkgs.grub2_efi
    pkgs.hexyl
    pkgs.killall
    pkgs.less
    pkgs.libsecret
    pkgs.mosh
    pkgs.netcat-gnu
    pkgs.nix-index
    pkgs.nix-ld
    pkgs.nmap
    pkgs.nodejs
    pkgs.openssl
    pkgs.ouch
    pkgs.pass
    pkgs.passh
    pkgs.phinger-cursors
    pkgs.pinentry-gnome3
    pkgs.pkg-config
    pkgs.podman-compose
    pkgs.powertop
    pkgs.pueue
    pkgs.qmk
    pkgs.qmk-udev-rules
    pkgs.qmk_hid
    pkgs.ripgrep
    pkgs.rm-improved
    pkgs.seahorse
    pkgs.starship
    pkgs.tealdeer
    pkgs.wget
    pkgs.wl-clipboard
    pkgs.xclip
    pkgs.xcp
    pkgs.xfce.thunar
    pkgs.xfce.tumbler
    pkgs.zellij
    pkgs.zoxide
    unstablePkgs.yazi
    # package managers
    pkgs.flatpak
    # back-end dev tools
    pkgs.brotli
    pkgs.gcc
    pkgs.gnumake
    unstablePkgs.just
    unstablePkgs.ruff
    unstablePkgs.serie
    unstablePkgs.uv
    # front-end dev environment
    pkgs.micro
    unstablePkgs.ghostty
    unstablePkgs.neovim
    unstablePkgs.nushell
    unstablePkgs.onefetch
    # DE and accompanying tools
    pkgs.wayland
    pkgs.wayland-utils
    pkgs.sway # More stable, backup DE
    pkgs.hyprland
    pkgs.hyprlock
    pkgs.hyprpaper
    pkgs.hyprpicker
    pkgs.hyprshot
    pkgs.xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal-wlr
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-xapp
    unstablePkgs.libnotify
    unstablePkgs.swaynotificationcenter
    unstablePkgs.waybar
    unstablePkgs.wofi
  ];

  hardware.keyboard.qmk.enable = true;

  # Activate DEs
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.sway = {
    enable = true;
    extraOptions = ["--unsupported-gpu"];
  };
  programs.waybar.enable = true;

  # Enable my preferred DE utilities
  programs.thunar.enable = true;
  programs.thunar.plugins = [
    pkgs.xfce.thunar-volman
    pkgs.xfce.thunar-archive-plugin
    pkgs.xfce.thunar-media-tags-plugin
  ];
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  programs.xfconf.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Disable automatically activated programs i dont want
  programs.foot.enable = false;

  # Lets also activate some handy devenv tools
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.nix-ld = {
    enable = true;
    libraries = [
      pkgs.acl
      pkgs.alsa-lib
      pkgs.at-spi2-core
      pkgs.attr
      pkgs.bzip2
      pkgs.curl
      pkgs.dbus
      pkgs.expat
      pkgs.glib
      pkgs.libsodium
      pkgs.libssh
      pkgs.libxml2
      pkgs.nspr
      pkgs.nss
      pkgs.openssl
      pkgs.pango
      pkgs.stdenv.cc
      pkgs.systemd
      pkgs.util-linux
      pkgs.vulkan-loader
      pkgs.xz
      pkgs.zlib
      pkgs.zstd
    ];
  };

  # Enable flatpaks
  services.flatpak.enable = true;

  # Enable the OpenSSH daemon and other remote tools.
  services.openssh.enable = true;
  programs.mosh.enable = true;

  # Add custom services
  systemd.services.pueued = {
    enable = true;
    description = "Pueue Daemon - CLI process scheduler and manager";
    wantedBy = ["default.target"];
    serviceConfig = {
      Restart = "no";
      ExecStart = "${pkgs.pueue.outPath}/bin/pueued -vv";
    };
  };

  # Enable GPG signing
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true; # enable the graphical frontend
  security.pam.services.gdm.enableGnomeKeyring = true; # load gnome-keyring at startup
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    enableSSHSupport = true;
  };

  virtualisation = {
    containers.enable = true;

    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      dockerSocket.enable = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };

    libvirtd.enable = true;
  };
  programs.virt-manager.enable = true;

  system = {
    stateVersion = "23.11"; # Did you read the comment?
    autoUpgrade.enable = true;
    autoUpgrade.dates = "weekly";
  };

  # Set user config settings
  users.defaultUserShell = pkgs.nushell;
}
