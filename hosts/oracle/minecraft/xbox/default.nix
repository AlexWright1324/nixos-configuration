{ config, pkgs, ... }:
{
  services.minecraft-servers.servers.xbox = {
    enable = true;

    package = pkgs.velocityServers.velocity.overrideAttrs (oldAttrs: {
      src = pkgs.fetchurl {
        url = "https://github.com/MCXboxBroadcast/Broadcaster/releases/download/83/MCXboxBroadcastStandalone.jar";
        hash = "sha256-D82RxS80JZUjJ2P25inwhZel9j7uDqhYnmI8jROX1HA=";
      };
    });
  };
}
