{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  services = {
    swaync.enable = true;
    pueue.enable = true;
    hyprpaper.enable = true;
  };
  # Custom version of ghostty service, to stop closing during update
  systemd.user.services."app-com.mitchellh.ghostty" = {
    Unit = {
      Description = "Ghostty Terminal Emulator";
      X-SwitchMethod = "keep-old";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${lib.getExe config.programs.ghostty.package}";
      Environment = "WAYLAND_DISPLAY=wayland-1";
      Type = "notify";
      ReloadSignal = "SIGUSR2";
      KillMode = "mixed";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
