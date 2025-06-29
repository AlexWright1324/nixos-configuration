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
        ];
      };

      "aquila" = inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./aquila
        ];
      };
    };
  };
}
