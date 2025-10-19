{
  moduleWithSystem,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.home-assistant-googlefindmy = pkgs.callPackage ./googlefindmy/package.nix { };
      packages.googlefindmytools = pkgs.callPackage ./googlefindmy/cli.nix { };
    };

  flake.nixosModules = {
    googlefindmytools = moduleWithSystem (
      perSystem@{ config, ... }:
      {
        config,
        ...
      }:
      {
        config.services.home-assistant.customComponents = [
          perSystem.config.packages.home-assistant-googlefindmy
        ];
      }
    );
  };
}
