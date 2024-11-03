{
  description = "Alex's NixOS System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
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

      flake = {
        checks = builtins.mapAttrs (
          system: deployLib: deployLib.deployChecks self.deploy
        ) inputs.deploy-rs.lib;
      };

      systems = import inputs.systems;

      # Development Environment
      perSystem =
        { config, pkgs, ... }:
        {
          pre-commit.settings.hooks = {
            nil.enable = true;
            nixfmt-rfc-style.enable = true;
          };

          devShells.default = pkgs.mkShell {
            inputsFrom = [
              config.pre-commit.devShell
            ];
            packages = with pkgs; [ deploy-rs ];
          };

          formatter = pkgs.nixfmt-rfc-style;
        };
    };
}
