{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  theme,
  ...
}: {
  services = {
    displayManager.defaultSession = "hyprland-uwsm";
    desktopManager.gnome.enable = false;
    displayManager.gdm.enable = false;
    greetd.enable = true;
    xserver = {
      videoDrivers = ["nvidia"]; # or "nvidiaLegacy470 etc.
      enable = true;
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

    # Add guix, as it is a common tool for reproducibility in comp sci
    guix.enable = true;

    # Enable the OpenSSH daemon and other remote tools.
    openssh.enable = true;

    gnome.gnome-keyring.enable = true;
    pcscd.enable = true;
    udev = {
      packages = [
        pkgs.yubikey-personalization
      ];
    };
  };

  # Add custom services
  systemd.services = {
    greetd = {
      after = ["setup-user-vars.service"];
      requires = ["setup-user-vars.service"];
    };
    setup-user-vars = {
      description = "Set user profile vars";
      wantedBy = [
        "multi-user.target"
        "graphical-session.target"
      ];
      after = ["home.mount"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.bash}/bin/bash -c " \
            mkdir -p /var/lib/AccountsService/{icons,users,wallpaper} && \
            cp ${theme.avatarSource} ${theme.avatar} && \
            echo '[User]\nSession=\nIcon=${theme.avatar}\nSystemAccount=false' > /var/lib/AccountsService/users/cianh && \
            chown root:root /var/lib/AccountsService/users/cianh && \
            chmod 0600 /var/lib/AccountsService/users/cianh && \
            chown root:root ${theme.avatar} && \
            chmod 0444 ${theme.avatar} && \
            cp ${theme.wallpaperSource} ${theme.wallpaper} && \
            chown root:root ${theme.wallpaper} && \
            chmod 0444 ${theme.wallpaper} \
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
