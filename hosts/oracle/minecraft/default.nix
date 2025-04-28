{ pkgs, ... }:
{
  imports = [
    ./velocity
    ./keira
  ];

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers = {
      fabric = {
        enable = true;

        package = pkgs.fabricServers.fabric-1_21_5.override {
          loaderVersion = "0.16.14";
        };
      };
    };
  };
}
