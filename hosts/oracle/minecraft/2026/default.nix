{ config, pkgs, ... }:
let
  name = "sogcraft";
in
{
  services.minecraft-servers.servers.${name} = {
    enable = true;

    package = pkgs.fabricServers.fabric-1_21_11.override {
      loaderVersion = "0.18.4";
    };

    serverProperties = {
      server-port = 30002;
      max-players = 69;
      motd = "sogcraft";
      enforce-secure-profile = false;
      difficulty = "normal";
    };

    symlinks = {
      "mods/fastback.jar" = pkgs.fetchurl {
        url = "https://cdn.modrinth.com/data/ZHKrK8Rp/versions/yqaOm9Fj/fastback-0.30.0%2B1.21.11-fabric.jar";
        hash = "sha256-/GEq3gC8QJdVbFrK5JcTQDmk+cuJX6kAkFOKfrDeEmk=";
      };
      "mods/FabricAPI.jar" = pkgs.fetchurl {
        pname = "FabricAPI";
        version = "0.140.2+1.21.11";
        url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/gB6TkYEJ/fabric-api-0.140.2%2B1.21.11.jar";
        hash = "sha256-t8RYO3/EihF5gsxZuizBDFO3K+zQHSXkAnCUgSb4QyE=";
      };
      "mods/FabricProxy-Lite.jar" = pkgs.fetchurl {
        pname = "FabricProxy-Lite";
        version = "2.11.0";
        url = "https://cdn.modrinth.com/data/8dI2tmqs/versions/nR8AIdvx/FabricProxy-Lite-2.11.0.jar";
        hash = "sha256-68er6vbAOsYZxwHrszLeaWbG2D7fq/AkNHIMj8PQPNw=";
      };
      "mods/voicechat-fabric.jar" = pkgs.fetchurl {
        pname = "voicechat-fabric";
        version = "2.6.10";
        url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/T42QJY4i/voicechat-fabric-1.21.11-2.6.10.jar";
        hash = "sha256-Bw++uNpoCuu7bQE/PSagtVFLBgoNKbtbBzSNBmbrGO0=";
      };
    };
  };

  system.activationScripts."${name}-proxy" = ''
    secret=$(cat "${config.age.secrets.forwardingSecret.path}")
    configFile=${../FabricProxy-Lite.toml}
    outFile=${config.services.minecraft-servers.dataDir}/${name}/config/FabricProxy-Lite.toml
    touch $outFile
    ${pkgs.gnused}/bin/sed "s#@forwardingSecret@#$secret#" "$configFile" > "$outFile"
  '';

  systemd.services."minecraft-server-${name}" = {
    restartTriggers = [ ../FabricProxy-Lite.toml ];
    path = with pkgs; [
      git
      git-lfs
      openssh
    ];
  };
}
