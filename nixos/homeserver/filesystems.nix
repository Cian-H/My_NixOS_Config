{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  fileSystems = {
    "/home/cianh/TV_Archive" = {
      device = "/dev/disk/by-uuid/2ac3aa3e-91bf-4a98-9fb6-3c0235545be9";
      fsType = "ext4";
      options = ["nofail" "x-systemd.automount"];
    };
    "/home/cianh/Nextcloud" = {
      device = "/dev/disk/by-uuid/10ebaf9a-f519-4990-b814-9d6825ad692f";
      fsType = "ext4";
      options = ["nofail" "x-systemd.automount"];
    };
  };
}
