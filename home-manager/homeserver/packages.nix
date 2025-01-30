{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages =
    (with pkgs; [
      (python3.withPackages (
        python-pkgs: [
          python-pkgs.pip
          python-pkgs.pkginfo
          python-pkgs.python-lsp-server
          python-pkgs.setuptools
        ]
      ))
      lua54Packages.lua
      luajitPackages.luarocks
      nodejs-slim
      sops
      stylua
    ])
    ++ (with unstablePkgs; [
      podman-tui
      vimPlugins.mason-lspconfig-nvim
    ]);
}
