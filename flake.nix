{
  description = "System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    spicetify-nix.url = "github:the-argus/spicetify-nix";
  };

  outputs = { nixpkgs, ... } @ inputs: {
    nixosConfigurations."Alex-PC-NixOS" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix # Your system configuration.

        inputs.chaotic.nixosModules.default # Chaotic Nyx
      ];
    };
  };
}