{ pkgs, ... }:
{
  services.minecraft-servers.servers.keira = {
    enable = true;

    package = pkgs.fabricServers.fabric-1_21_5.override {
      loaderVersion = "0.16.14";
    };
  };
}
