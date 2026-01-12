{ config, pkgs, ... }:
{
  services.minecraft-servers.servers.xbox = {
    enable = true;

    package = pkgs.velocityServers.velocity.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = "https://github.com/MCXboxBroadcast/Broadcaster/releases/download/118/MCXboxBroadcastStandalone.jar";
        hash = "sha256-nqhZ81TSNh+syNnJd7t5JNzHIz4GJy3y+pC/0DP4hlU=";
      };
    });
  };
}
