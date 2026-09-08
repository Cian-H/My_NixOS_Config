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
    ollama = {
      enable = true;
      acceleration = "cuda";
    };
    pueue.enable = true;
    podman = {
      enable = true;
      enableTypeChecks = true;
      autoUpdate.enable = true;
      containers."9router" = {
        image = "decolua/9router:latest";
        autoStart = true;
        network = "host";
        ports = [
          "20128:20128"
        ];
        volumes = [
          "9router-data:/data"
        ];
      };
    };
  };
  # Custom version of ghostty service, to stop closing during update
  systemd.user.services = {
    "app-com.mitchellh.ghostty" = {
      Unit = {
        Description = "Ghostty Terminal Emulator";
        X-SwitchMethod = "keep-old";
        X-RestartIfChanged = false;
        After = ["graphical-session.target"];
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
    "podman-user-wait-network-online" = {
      Service = {
        ExecStart = [
          ""
          "${pkgs.coreutils}/bin/true"
        ];
      };
    };
  };
}
