{ self, moduleWithSystem, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.system-bridge = pkgs.callPackage ./package.nix { };
    };

  flake.nixosModules.system-bridge = moduleWithSystem (
    perSystem@{ config, ... }:
    {
      config,
      lib,
      pkgs,
      ...
    }:
    with lib;
    {

    }
  );
}
