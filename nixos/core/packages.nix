{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.atuin
    pkgs.bat
    pkgs.bitwarden-cli
    pkgs.bottom
    pkgs.brotli
    pkgs.delta
    pkgs.du-dust
    pkgs.duf
    pkgs.fastfetch
    pkgs.fd
    pkgs.fzf
    pkgs.gcc
    pkgs.gh
    pkgs.git
    pkgs.git-extras
    pkgs.glab
    pkgs.glow
    pkgs.gnumake
    pkgs.gnupg
    pkgs.hexyl
    pkgs.killall
    pkgs.less
    pkgs.libsecret
    pkgs.micro
    pkgs.netcat-gnu
    pkgs.nix-index
    pkgs.openssl
    pkgs.ouch
    pkgs.pass
    pkgs.passh
    pkgs.pkg-config
    pkgs.podman-compose
    pkgs.powertop
    pkgs.pueue
    pkgs.ripgrep
    pkgs.rm-improved
    pkgs.starship
    pkgs.tealdeer
    pkgs.wget
    pkgs.wl-clipboard
    pkgs.xclip
    pkgs.xcp
    pkgs.zellij
    pkgs.zoxide
    unstablePkgs.just
    unstablePkgs.neovim
    unstablePkgs.nushell
    unstablePkgs.onefetch
    unstablePkgs.serie
    unstablePkgs.yazi
  ];
}
