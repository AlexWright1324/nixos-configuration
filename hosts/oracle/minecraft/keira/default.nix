{ config, pkgs, ... }:
{
  services.minecraft-servers.servers.keira = {
    enable = true;

    package = pkgs.fabricServers.fabric-1_21_5.override {
      loaderVersion = "0.16.14";
    };

    serverProperties = {
      server-port = 30001;
      max-players = 69;
      motd = "Keira's World";
    };

    symlinks = {
      "mods/fastback.jar" = pkgs.fetchurl {
        url = "https://github.com/pcal43/fastback/releases/download/0.24.1%2B1.21.5/fastback-0.24.1+1.21.5-fabric.jar";
        hash = "sha256-jyGHV4vpxmApOlxVqArN0WarY37DmBvDBrVKlx+cDgM=";
      };
      # FabricProxy-Lite
    };
  };

  system.activationScripts."keira-proxy" = ''
    secret=$(cat "${config.age.secrets.forwardingSecret.path}")
    configFile=${./FabricProxy-Lite.toml}
    ${pkgs.gnused}/bin/sed "s#@forwardingSecret@#$secret#" "$configFile" > ${config.services.minecraft-servers.dataDir}/keira/config/FabricProxy-Lite.toml
  '';

  systemd.services."minecraft-server-keira" = {
    restartTriggers = [ ./FabricProxy-Lite.toml ];
    path = with pkgs; [
      git
      git-lfs
      openssh
    ];
  };
}
