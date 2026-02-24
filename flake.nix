{
  description = "Cian-H's nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    # Nixpkgs-unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Nixers
    nixers-repo.url = "github:Cian-H/Nixers";
    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # Add sops for secret management
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixers-repo,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    worklaptopTheme = pkgs: {
      theme = {
        name = "Tokyonight-Dark";
        package = pkgs.tokyonight-gtk-theme;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = "phinger-cursors-dark";
        package = pkgs.phinger-cursors;
      };
      fonts = {
        serif = "NotoSerifNerdFont";
        sansSerif = "NotoSansNerdFont";
        monospace = "MonaspiceArNerdFontMono";
      };
      wallpaperSource = "/home/cianh/Pictures/Wallpapers/City_1_Upscaled.png";
      wallpaper = "/var/lib/AccountsService/wallpaper/cianh";
      avatarSource = "/home/cianh/Pictures/face.png";
      avatar = "/var/lib/AccountsService/icons/cianh";
    };
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      worklaptop = let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
            cudaSupport = true;
            allowUnfreePredicate = _: true;
          };
        };
      in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
            nixers = inputs.nixers-repo.packages.x86_64-linux;
            theme = worklaptopTheme pkgs;
          };
          modules = [
            ./nixos/worklaptop.nix
          ];
        };
      homeserver = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
          nixers = inputs.nixers-repo.packages.x86_64-linux;
        };
        modules = [
          ./nixos/homeserver.nix
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "cianh@core" = let
        pkgs = import nixpkgs {
          # Home-manager requires 'pkgs' instance
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
            # Workaround for https://github.com/nix-community/home-manager/issues/2942
            allowUnfreePredicate = _: true;
          };
        };
      in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs outputs;
            unstablePkgs = import nixpkgs-unstable {
              # We also need to do the same for unstable
              system = pkgs.stdenv.hostPlatform.system;
              config = {
                allowUnfree = true;
                allowUnfreePredicate = _: true;
              };
            };
            nixers = inputs.nixers-repo.packages.${pkgs.stdenv.hostPlatform.system};
          };
          modules = [
            ./home-manager/core.nix
          ];
        };
      "cianh@worklaptop" = let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
            cudaSupport = true;
            allowUnfreePredicate = _: true;
          };
        };
      in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit inputs outputs;
            unstablePkgs = import nixpkgs-unstable {
              system = "x86_64-linux";
              cudaSupport = true;
              config = {
                allowUnfree = true;
                allowUnfreePredicate = _: true;
              };
            };
            nixers = inputs.nixers-repo.packages.${pkgs.stdenv.hostPlatform.system};
            theme = worklaptopTheme pkgs;
          };

          modules = [
            ./home-manager/worklaptop.nix
          ];
        };
      "cianh@homeserver" = let
        pkgs = import nixpkgs {
          # Home-manager requires 'pkgs' instance
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
            # Workaround for https://github.com/nix-community/home-manager/issues/2942
            allowUnfreePredicate = _: true;
          };
        };
      in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs outputs;
            unstablePkgs = import nixpkgs-unstable {
              # We also need to do the same for unstable
              system = "x86_64-linux";
              config = {
                allowUnfree = true;
                allowUnfreePredicate = _: true;
              };
            };
            nixers = inputs.nixers-repo.packages.${pkgs.stdenv.hostPlatform.system};
          };
          modules = [
            ./home-manager/homeserver.nix
          ];
        };
    };
  };
}
