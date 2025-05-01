{ inputs, ... }:
{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers

    ./velocity
    ./lobby
    ./keira
  ];

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
  };
}
