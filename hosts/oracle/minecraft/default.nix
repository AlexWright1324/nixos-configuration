{ pkgs, ... }:
{
  imports = [
    ./keira
  ];
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers = {
      fabric = {
        enable = true;

        package = pkgs.fabricServers.fabric-1_21_5.override {
          loaderVersion = "0.16.14";
        };

        symlinks = {
          mods = pkgs.linkFarmFromDrvs "mods" (
            builtins.attrValues {
              #Fabric-API = pkgs.fetchurl {
              #  url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/9YVrKY0Z/fabric-api-0.115.0%2B1.21.1.jar";
              #  sha512 = "e5f3c3431b96b281300dd118ee523379ff6a774c0e864eab8d159af32e5425c915f8664b1";
              #};
            }
          );
        };
      };
    };
  };
}
