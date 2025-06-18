{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  services = {
    # Enable the OpenSSH daemon and other remote tools.
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
      extraConfig = "UsePAM yes";
    };
    # Enable GPG signing
    pcscd.enable = true;
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
}
