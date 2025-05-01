{ config, pkgs, ... }:
{
  services.minecraft-servers.servers.lobby = {
    enable = true;

    package = pkgs.velocityServers.velocity.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = "https://github.com/BoomEaro/NanoLimbo/releases/download/1.21.5_1.9_1/NanoLimbo-1.9.1-all.jar";
        hash = "sha256-z33SIlt/qqiTLjS/zmJ5h9TAqJLV608HgAd8xLMN9X8=";
      };
    });
  };

  system.activationScripts."lobby-config" = ''
    secret=$(cat "${config.age.secrets.forwardingSecret.path}")
    configFile=${./settings.yml}
    ${pkgs.gnused}/bin/sed "s#@forwardingSecret@#$secret#" "$configFile" > ${config.services.minecraft-servers.dataDir}/lobby/settings.yml
  '';
}
