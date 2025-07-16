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
  systemd.services = {
    setup-user-icon = {
      description = "Set user profile icon";
      wantedBy = ["multi-user.target"];
      after = ["home.mount"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.bash}/bin/bash -c " \
            mkdir -p /var/lib/AccountsService/{icons,users} && \
            cp /home/cianh/Pictures/face.png /var/lib/AccountsService/icons/cianh && \
            echo '[User]\nSession=\nIcon=/var/lib/AccountsService/icons/cianh\nSystemAccount=false' > /var/lib/AccountsService/users/cianh && \
            chown root:root /var/lib/AccountsService/users/cianh && \
            chmod 0600 /var/lib/AccountsService/users/cianh && \
            chown root:root /var/lib/AccountsService/icons/cianh && \
            chmod 0444 /var/lib/AccountsService/icons/cianh \
          "
        '';
      };
    };
    pueued = {
      enable = true;
      description = "Pueue Daemon - CLI process scheduler and manager";
      wantedBy = ["default.target"];
      serviceConfig = {
        Restart = "no";
        ExecStart = "${pkgs.pueue.outPath}/bin/pueued -vv";
      };
    };
  };

  # Enable GPG signing
  security.pam.services.gdm.enableGnomeKeyring = true; # load gnome-keyring at startup
}
