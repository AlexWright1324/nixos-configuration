{
  description = "Alex's NixOS System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Development tooling
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    pre-commit-hooks-nix = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "";
    };
    systems.url = "github:nix-systems/default";
  };

  outputs =
    { self, ... }@inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.pre-commit-hooks-nix.flakeModule
        ./hosts
      ];

      systems = import inputs.systems;

      perSystem =
        { config, pkgs, ... }:
        {
          pre-commit.settings.hooks = {
            nil.enable = true;
            nixfmt-rfc-style.enable = true;
          };

          formatter = pkgs.nixfmt-rfc-style;

          devShells.default = pkgs.mkShell {
            inputsFrom = [
              # Include packages from pre-commit hooks
              config.pre-commit.devShell
            ];

            # Custom dev packages
            # packages = with pkgs; [ ];
          };
        };
    };
}
