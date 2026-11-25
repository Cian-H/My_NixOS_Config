{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-tty;
    enableSSHSupport = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = [
      pkgs.acl
      pkgs.attr
      pkgs.bzip2
      pkgs.curl
      pkgs.dbus
      pkgs.expat
      pkgs.glib
      pkgs.libsodium
      pkgs.libssh
      pkgs.libxml2
      pkgs.nspr
      pkgs.nss
      pkgs.openssl
      pkgs.stdenv.cc
      pkgs.systemd
      pkgs.util-linux
      pkgs.xz
      pkgs.zlib
      pkgs.zstd
    ];
  };
}
