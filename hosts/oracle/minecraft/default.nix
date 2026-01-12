{ inputs, lib, ... }:
{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers

    ./velocity
    ./xbox
    ./lobby
    # ./keira # Disabled until keira wants it :P
    ./2026
  ];

  nixpkgs.overlays = lib.mkForce [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
  };

  age.secrets.forwardingSecret = {
    file = ../secrets/forwardingSecret.age;
    owner = "minecraft";
    group = "minecraft";
  };
}
