{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages = [
    (pkgs.python3.withPackages (
      python-pkgs: [
        python-pkgs.pkginfo
        python-pkgs.python-lsp-server
        python-pkgs.setuptools
      ]
    ))
    pkgs.lua54Packages.lua
    pkgs.luajitPackages.luarocks
    pkgs.nodejs-slim
    pkgs.sops
    pkgs.stylua
    unstablePkgs.podman-tui
    unstablePkgs.vimPlugins.mason-lspconfig-nvim
  ];
}
