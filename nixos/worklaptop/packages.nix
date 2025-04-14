{
  inputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.flatpak
    pkgs.gdm
    pkgs.grub2_efi
    pkgs.hyprland
    pkgs.hyprlock
    pkgs.hyprpaper
    pkgs.hyprpicker
    pkgs.hyprshot
    pkgs.mosh
    pkgs.nix-ld
    pkgs.nmap
    pkgs.nodejs
    pkgs.phinger-cursors
    pkgs.pinentry-gnome3
    pkgs.qmk
    pkgs.qmk-udev-rules
    pkgs.qmk_hid
    pkgs.seahorse
    pkgs.sway # More stable, backup DE
    pkgs.wayland
    pkgs.wayland-utils
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal-wlr
    pkgs.xdg-desktop-portal-xapp
    pkgs.xfce.thunar
    pkgs.xfce.tumbler
    unstablePkgs.ghostty
    unstablePkgs.libnotify
    unstablePkgs.ruff
    unstablePkgs.swaynotificationcenter
    unstablePkgs.uv
    unstablePkgs.waybar
    unstablePkgs.wofi
  ];
}
