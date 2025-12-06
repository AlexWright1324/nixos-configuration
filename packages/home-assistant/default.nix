{
  ...
}:
{
  flake.overlays.home-assistant = final: prev: {
    home-assistant-custom-components = prev.home-assistant-custom-components // {
      googlefindmy = prev.callPackage ./googlefindmy/package.nix { };
      linksys_velop = prev.callPackage ./linksys_velop.nix {
        pyvelop = prev.home-assistant.python.pkgs.callPackage ./pyvelop.nix { };
      };
    };
    googlefindmytools = prev.callPackage ./googlefindmy/cli.nix { };
  };
}
