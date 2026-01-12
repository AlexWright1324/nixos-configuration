{
  withSystem,
  inputs,
  ...
}:
let
  mkNixosSystem =
    system: modules:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      modules = modules ++ [
        {
          nixpkgs.pkgs = withSystem system ({ pkgs, ... }: pkgs);
        }
      ];
    };
in
{
  flake = {
    nixosConfigurations = {
      "Alex-PC-NixOS" = mkNixosSystem "x86_64-linux" [
        ./alex-pc
      ];

      "Frank-Laptop-NixOS" = mkNixosSystem "x86_64-linux" [
        ./frank-laptop
      ];

      "oracle" = mkNixosSystem "aarch64-linux" [
        ./oracle
      ];

      "aquila" = mkNixosSystem "aarch64-linux" [
        # Build NixOS SD card image for Aquila
        # > nix build .#nixosConfigurations.aquila.config.system.build.sdImage
        "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        ./aquila
      ];

      "xyber" = mkNixosSystem "x86_64-linux" [
        ./xyber
      ];
    };
  };
}
