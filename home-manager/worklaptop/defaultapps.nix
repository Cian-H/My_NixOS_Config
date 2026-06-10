{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Directories and Archives
      "inode/directory" = "thunar.desktop";
      "application/zip" = "xarchiver.desktop";

      # PDFs
      "application/pdf" = "sioyek.desktop";

      # Web Browser (Vivaldi)
      "text/html" = "vivaldi-stable.desktop";
      "x-scheme-handler/http" = "vivaldi-stable.desktop";
      "x-scheme-handler/https" = "vivaldi-stable.desktop";
      "x-scheme-handler/about" = "vivaldi-stable.desktop";
      "x-scheme-handler/unknown" = "vivaldi-stable.desktop";

      # Text and Code (Neovide)
      "text/plain" = "neovide.desktop";
      "text/markdown" = "neovide.desktop";

      # Images (imv)
      "image/jpeg" = "imv.desktop";
      "image/png" = "imv.desktop";
      "image/gif" = "imv.desktop";
      "image/webp" = "imv.desktop";
      "image/svg+xml" = "imv.desktop";
      "image/tiff" = "imv.desktop";
      "image/bmp" = "imv.desktop";

      # Office Files (OnlyOffice)
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "onlyoffice-desktopeditors.desktop"; # .docx
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "onlyoffice-desktopeditors.desktop"; # .xlsx
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "onlyoffice-desktopeditors.desktop"; # .pptx
      "application/msword" = "onlyoffice-desktopeditors.desktop"; # .doc
      "application/vnd.ms-excel" = "onlyoffice-desktopeditors.desktop"; # .xls
      "application/vnd.ms-powerpoint" = "onlyoffice-desktopeditors.desktop"; # .ppt
      "application/vnd.oasis.opendocument.text" = "onlyoffice-desktopeditors.desktop"; # .odt
      "application/vnd.oasis.opendocument.spreadsheet" = "onlyoffice-desktopeditors.desktop"; # .ods
      "application/vnd.oasis.opendocument.presentation" = "onlyoffice-desktopeditors.desktop"; # .odp
    };
  };
}
