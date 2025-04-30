{
  inputs,
  ...
}:
{
  imports = [
    ./deploy.nix
  ];

  flake = {
    nixosConfigurations = {
      "Alex-PC-NixOS" = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./alex-pc
        ];
      };

      "Frank-Laptop-NixOS" = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          inputs.sops-nix.nixosModules.sops
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
          inputs.sops-nix.nixosModules.sops

          inputs.nix-minecraft.nixosModules.minecraft-servers
          {
            nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
          }
        ];
      };
    };

    # WIP: OCI Image
    #packages = {
    #  "aarch64-linux" = nixosConfigurations.oci.config.system.build.OCIImage;
    #};
  };
}
