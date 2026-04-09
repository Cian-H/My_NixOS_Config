{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstablePkgs,
  nixers,
  ...
}: {
  imports = [
    inputs.noctalia.homeModules.default
    inputs.spicetify-nix.homeManagerModules.default
  ];

  programs = {
    nix-your-shell = {
      enable = true;
      enableNushellIntegration = true;
    };
    direnv = {
      enable = true;
      enableNushellIntegration = true;
    };
    noctalia-shell.enable = true;
    walker = {
      enable = true;
      runAsService = true;
    };
    rbw = {
      enable = true;
      settings = {
        email = "chughes000@gmail.com";
        pinentry = nixers.rbw-autofill;
      };
    };
    hyprcursor-phinger.enable = true;
    spicetify = let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in {
      enable = true;
      theme = {
        name = "TokyoNight";
        src = pkgs.fetchFromGitHub {
          owner = "evening-hs";
          repo = "Spotify-Tokyo-Night-Theme";
          rev = "main";
          hash = "sha256-cLj9v8qtHsdV9FfzV2Qf4pWO8AOBXu51U/lUMvdEXAk=";
        };
        appendName = false;
        injectCss = true;
        replaceColors = true;
        overwriteAssets = true;
      };
      colorScheme = "Night";
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        shuffle
        hidePodcasts
        fullAppDisplay
        trashbin
      ];
    };
  };
}
