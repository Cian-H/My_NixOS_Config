{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  users.users."cianh".openssh.authorizedKeys.keyFiles = [
    ./ssh/authorized_keys
  ];
}
