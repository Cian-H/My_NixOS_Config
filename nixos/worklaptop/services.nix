{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
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
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    gvfs.enable = true;
    tumbler.enable = true;

    # Enable flatpaks
    flatpak.enable = true;

    # Enable the OpenSSH daemon and other remote tools.
    openssh.enable = true;

    gnome.gnome-keyring.enable = true;
    pcscd.enable = true;
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
  security.pam.services.gdm.enableGnomeKeyring = true; # load gnome-keyring at startup
}
