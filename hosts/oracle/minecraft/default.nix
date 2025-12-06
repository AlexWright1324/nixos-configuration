{ inputs, lib, ... }:
{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers

    ./velocity
    ./xbox
    ./lobby
    ./keira
  ];

  nixpkgs.overlays = lib.mkForce [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
  };

  age.secrets.forwardingSecret = {
    file = ./forwardingSecret.age;
    owner = "minecraft";
    group = "minecraft";
  };
}
