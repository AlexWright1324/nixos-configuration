{ inputs, self, ... }:
{
  flake = {
    nixosConfigurations = {
      "Alex-PC-NixOS" = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./alex-pc
          inputs.chaotic.nixosModules.default # Chaotic Nyx
          inputs.nix-index-database.nixosModules.nix-index # Nix Index

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

      "oracle" = inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./oracle
          inputs.nix-minecraft.nixosModules.minecraft-servers
          {
            nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
          }
        ];
      };
    };

    checks = builtins.mapAttrs (
      system: deployLib: deployLib.deployChecks self.deploy
    ) inputs.deploy-rs.lib;

    # WIP: OCI Image
    #packages = {
    #  "aarch64-linux" = nixosConfigurations.oci.config.system.build.OCIImage;
    #};
  };
}
