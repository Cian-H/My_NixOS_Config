{
  description = "Cian-H's nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # Nixpkgs-unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # Add sops for secret management
    sops-nix.url = "github:Mic92/sops-nix";
    # add phinger hyprcursor flake
    hyprcursor-phinger.url = "github:jappie3/hyprcursor-phinger";
    # add zen browser flake
    zen-browser.url = "github:Cian-H/zen-browser-flake";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      worklaptop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
        };
        modules = [
          ./nixos/worklaptop/configuration.nix
        ];
      };
      homeserver = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
        };
        modules = [
          ./nixos/homeserver/configuration.nix
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "cianh@core" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          # Home-manager requires 'pkgs' instance
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
            # Workaround for https://github.com/nix-community/home-manager/issues/2942
            allowUnfreePredicate = _: true;
          };
        };
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
        };
        modules = [
          ./home-manager/core.nix
        ];
      };
      "cianh@worklaptop" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          # Home-manager requires 'pkgs' instance
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
            cudaSupport = true;
            # Workaround for https://github.com/nix-community/home-manager/issues/2942
            allowUnfreePredicate = _: true;
          };
        };
        extraSpecialArgs = {
          inherit inputs outputs;
          unstablePkgs = import nixpkgs-unstable {
            # We also need to do the same for unstable
            system = "x86_64-linux";
            cudaSupport = true;
            config = {
              allowUnfree = true;
              allowUnfreePredicate = _: true;
            };
          };
        };
        modules = [
          ./home-manager/worklaptop.nix
        ];
      };
      "cianh@homeserver" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          # Home-manager requires 'pkgs' instance
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
            # Workaround for https://github.com/nix-community/home-manager/issues/2942
            allowUnfreePredicate = _: true;
          };
        };
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
        };
        modules = [
          ./home-manager/homeserver.nix
        ];
      };
    };
  };
}
