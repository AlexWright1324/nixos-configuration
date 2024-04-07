{
  description = "System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-alien.url = "github:thiagokokada/nix-alien";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { nixpkgs, chaotic, nix-alien, nur, ... }: {
    nixosConfigurations."Alex-PC-NixOS" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix # Your system configuration.
          chaotic.nixosModules.default # Chaotic Nyx
          nur.nixosModules.nur # NUR Repos
          # Nix-alien
          ({ self, system, ... }: {
            environment.systemPackages = with self.inputs.nix-alien.packages.${system}; [
              nix-alien
            ];
            # Optional, needed for `nix-alien-ld`
            programs.nix-ld.enable = true;
          })
        ];
    };
  };
}