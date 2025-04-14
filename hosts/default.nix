{ inputs, ... }:
{
  flake = rec {
    nixosConfigurations = {
      "Alex-PC-NixOS" = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./alex-pc
          inputs.nix-index-database.nixosModules.nix-index # Nix Index
          inputs.chaotic.nixosModules.default # Chaotic Nyx

          # Cosmic
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          inputs.nixos-cosmic.nixosModules.default

          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
              };
            };
          }
        ];
      };

      "Frank-Laptop-NixOS" = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./frank-laptop
        ];
      };
    };

    deploy.nodes."Frank-Laptop-NixOS" = {
      hostname = "192.168.1.235";

      interactiveSudo = true;
      remoteBuild = true;

      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos nixosConfigurations."Frank-Laptop-NixOS";
      };
    };
  };
}
