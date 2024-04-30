{
  description = "System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-alien.url = "github:thiagokokada/nix-alien";
    nur.url = "github:nix-community/NUR";
    spicetify-nix.url = "github:the-argus/spicetify-nix";
  };

  outputs = { nixpkgs, ... } @ inputs: {
    nixosConfigurations."Alex-PC-NixOS" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix # Your system configuration.
        ./nix-alien.nix # Nix-alien

        inputs.chaotic.nixosModules.default # Chaotic Nyx
        inputs.nur.nixosModules.nur # NUR Repos
        inputs.spicetify-nix.nixosModule.default # Spicetify
      ];
    };
  };
}