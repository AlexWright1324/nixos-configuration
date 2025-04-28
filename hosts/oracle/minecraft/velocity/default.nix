{ pkgs, ... }:
{
  services.minecraft-servers.servers.velocity = {
    enable = true;
    openFirewall = true;

    package = pkgs.velocityServers.velocity;

  };
}
