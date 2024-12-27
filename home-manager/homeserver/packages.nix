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
      podman-tui
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
      stylua
    ])
    ++ (with unstablePkgs; [
      vimPlugins.mason-lspconfig-nvim
    ]);
}
