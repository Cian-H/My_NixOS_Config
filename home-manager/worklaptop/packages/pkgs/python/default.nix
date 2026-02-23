{pkgs}:
pkgs.python314.withPackages (
  python-pkgs: [
    python-pkgs.pkginfo
    python-pkgs.setuptools
  ]
)
