# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ...}:

{
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # First, enable nvidia specific config settings
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"]; # or "nvidiaLegacy470 etc.

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.efi.canTouchEfiVariables = true;
  # Enable hibernation
  boot.resumeDevice = "/dev/disk/by-uuid/526c41a3-66ec-4c6e-ad28-a32dfa99933e";

  networking.hostName = "worklaptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "ie";
    xkbVariant = "";
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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Apply overrides
  # nixpkgs.config.packageOverrides = pkgs: {
  #   # For data science, python optimisations are important # NOTE: Scratch that, the 3hr+ compilation time isnt worth it
  #   python3 = pkgs.python3.override {
  #     enableOptimizations = true;
  #     reproducibleBuild = false;
  #   };
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.cianh = {
  #   isNormalUser = true;
  #   description = "Cian Hughes";
  #   extraGroups = [ "networkmanager" "wheel" ];
  #   packages = with pkgs; [
  #     bitwarden
  #     bitwarden-cli
  #     caffeine-ng
  #     cinnamon.warpinator
  #     direnv
  #     feh
  #     ferdium
  #     gimp-with-plugins
  #     github-desktop
  #     glow
  #     gnome.gnome-boxes
  #     helix
  #     hyperfine
  #     imagemagick
  #     inkscape-with-extensions
  #     krita
  #     libreoffice
  #     lynx
  #     marker
  #     mendeley
  #     mermaid-cli
  #     nix-direnv
  #     nwg-look
  #     obs-studio
  #     pandoc
  #     podman
  #     podman-desktop
  #     podman-tui
  #     slack
  #     spice-vdagent
  #     spotify
  #     stow
  #     tmux
  #     vivaldi
  #     vscode
  #     # theming
  #     phinger-cursors
  #     tokyo-night-gtk
  #     # gnome extensions
  #     gnome.gnome-tweaks
  #     gnome.dconf-editor
  #     gnomeExtensions.caffeine
  #     gnomeExtensions.freon
  #     gnomeExtensions.smile-complementary-extension
  #     gnomeExtensions.user-themes
  #     # alternative DEs and accompanying tools
  #     hyprland
  #     hyprpaper
  #     qt6ct
  #     swaynotificationcenter
  #     waybar
  #     wofi
  #     # kitty extensions
  #     kitty-img
  #     kitty-themes
  #     # Python packages
  #     pypy3
  #     (python3.withPackages(
  #       python-pkgs: [
  #         python-pkgs.pip
  #         python-pkgs.python-lsp-server
  #         python-pkgs.pynvim
  #       ]
  #     ))
  #     python310
  #     python311
  #     python312
  #     # Backend dev tools
  #     cmake
  #     elixir
  #     elixir-ls
  #     erlang_26
  #     evcxr
  #     fortran-fpm
  #     gcc
  #     gfortran
  #     gleam
  #     gnumake
  #     go
  #     jujutsu
  #     julia
  #     lua-language-server
  #     luajitPackages.luarocks
  #     mypy
  #     nil
  #     nixpkgs-fmt
  #     php83
  #     php83Packages.composer
  #     poetry
  #     pre-commit
  #     rm-improved
  #     ruff
  #     ruff-lsp
  #     rust-analyzer
  #     rustup
  #     starship
  #     stylua
  #     tree-sitter
  #     wget
  #     xclip
  #     zulu
  #   ];
  # };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # shell env programs
    atuin
    bat
    byobu
    du-dust
    duf
    fastfetch
    fd
    fzf
    gh
    git
    grub2_efi
    htop
    jq
    less
    mosh
    netcat-gnu
    nodejs_21
    nushell
    onefetch
    powertop
    ranger
    ripgrep
    tealdeer
    thefuck
    unzip
    xcp
    zoxide
    # package managers
    flatpak
    gnome.gnome-software
    # fonts
    corefonts
    liberation_ttf
    # monaspace
    nerdfonts
    noto-fonts
    noto-fonts-color-emoji
    vistafonts
    winePackages.fonts
    # alternative DEs and accompanying tools
    hyprland
    hyprpaper
    qt6ct
    swaynotificationcenter
    waybar
    wofi
    # front-end dev environment
    kitty
    micro
    neovim
  ];

  # Remove unwanted gnome packages
  environment.gnome.excludePackages = with pkgs; [
    gnome.epiphany
    gnome.geary
    gnome.gnome-music
    gnome-tour
    gnome.yelp
  ];

  # Activate alternative DEs
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    enableNvidiaPatches = true;
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.direnv.package = true;
  programs.direnv.nix-direnv.enable = true;

  # List services that you want to enable:
  
  services.flatpak.enable = true;

  # Enable the OpenSSH daemon and other remote tools.
  services.openssh.enable = true;
  programs.mosh.enable = true;
  services.gnome.gnome-remote-desktop.enable = true;
  services.gnome.gnome-user-share.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  virtualisation = {
    containers.enable = true;

    podman = {
      enable = true;
      enableNvidia = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
  system.autoUpgrade.enable = true;

  # Set user config settings
  users.defaultUserShell = pkgs.nushell;
}
