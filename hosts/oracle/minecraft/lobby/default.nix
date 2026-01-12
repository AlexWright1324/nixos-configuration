{ config, pkgs, ... }:
{
  services.minecraft-servers.servers.lobby = {
    enable = true;

    package = pkgs.velocityServers.velocity.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        pname = "NanoLimbo";
        url = "https://github.com/BoomEaro/NanoLimbo/releases/download/1.10.2/NanoLimbo.jar";
        version = "1.10.2";
        hash = "sha256-GVNpXTIAN+oed5m5Dz/pCpn04lEvTybl2K5b0xKYUxE=";
      };
    });
  };

  system.activationScripts."lobby-config" = ''
    secret=$(cat "${config.age.secrets.forwardingSecret.path}")
    configFile=${./settings.yml}
    ${pkgs.gnused}/bin/sed "s#@forwardingSecret@#$secret#" "$configFile" > ${config.services.minecraft-servers.dataDir}/lobby/settings.yml
  '';
}
