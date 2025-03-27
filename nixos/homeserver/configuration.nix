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
    ./filesystems.nix
    ./firewall.nix
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

  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry
    // {
      "justfile" = {
        text = ''
          default:
              @just -g --list

          update-root:
              if `/usr/bin/env grep -Rq "nixos" /etc/*-release`; then \
                  nixos-rebuild switch --flake /home/cianh/.config/nix/#$HOSTNAME; \
              fi
        '';
        mode = "0644";
      };
      "root_gitconfig" = {
        text = ''
          [safe]
              directory = /home/cianh/.config/nix
        '';
      };
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
        ./ssh/authorized_keys
      ];
    };

    root = {
      shell = pkgs.bashInteractive;
      openssh.authorizedKeys.keyFiles = [
        ./ssh/authorized_keys
      ];
      extraGroups = ["docker" "podman" "nixcfg"];
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
      pueue
      pinentry-tty
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
    extraConfig = "UsePAM yes";
  };
  # Modify the SSH service to prioritise because server is headless
  systemd.services.sshd = {
    requires = []; # Remove any non-essential dependencies
    after = ["network.target"]; # Only need to wait for networking (obviously)
    serviceConfig = {
      # If SSH dies, we want to restart it asap
      Restart = "always";
      RestartSec = "3";
      StartLimitIntervalSec = "0";
      # The CPU should never be too busy to respond to SSH
      CPUSchedulingPolicy = "rr";
      CPUSchedulingPriority = "99";
      IOSchedulingClass = "realtime";
      IOSchedulingPriority = "0";
      # Finally, if the system hits an OOM, for the love of god dont kill SSH until last
      OOMScoreAdjust = "-1000";
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
    pinentryPackage = pkgs.pinentry-tty;
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
    packages = with pkgs; [
      nerdfonts
    ];
  };
}
