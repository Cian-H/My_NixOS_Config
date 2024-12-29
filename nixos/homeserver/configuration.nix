{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Bootloader.
  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = true;
      };
    };
  };

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

  # Configure console keymap
  console.keyMap = "uk";

  users.users = {
    cianh = {
      isNormalUser = true;
      hashedPasswordFile = "/etc/hashedPasswordFile";
      description = "Cian Hughes";
      extraGroups = ["networkmanager" "wheel" "libvirtd"];
      shell = unstablePkgs.nushell;
      openssh.authorizedKeys.keyFiles = [
        ./ssh/authorized_keys
      ];
    };

    root = {
      shell = pkgs.bashInteractive;
      openssh.authorizedKeys.keyFiles = [
        ./ssh/authorized_keys
      ];
    };
  };

  # $ nix search wget
  environment.systemPackages =
    (with pkgs; [
      atuin
      bat
      bitwarden-cli
      bottom
      delta
      du-dust
      duf
      fastfetch
      fd
      fzf
      gh
      git
      git-extras
      glab
      glow
      gnupg
      grub2_efi
      hexyl
      killall
      less
      libsecret
      netcat-gnu
      nix-index
      openssl
      ouch
      pass
      passh
      pinentry-curses
      pkg-config
      podman-compose
      powertop
      pueue
      ripgrep
      rm-improved
      starship
      tealdeer
      wget
      wl-clipboard
      xclip
      xcp
      zellij
      zoxide
      monaspace
      nerdfonts
      brotli
      gcc
      gnumake
      micro
    ])
    ++ (with unstablePkgs; [
      just
      neovim
      nushell
      onefetch
      serie
      yazi
    ]);

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;
    withRuby = true;
  };

  # Enable the OpenSSH daemon and other remote tools.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

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
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };

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

  system.stateVersion = "24.11"; # Did you read the comment?
  system.autoUpgrade.enable = true;

  # Set user config settings
  users.defaultUserShell = pkgs.nushell;
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    fontconfig.defaultFonts.monospace = ["MonaspiceArNerdFontMono"];
  };
}
