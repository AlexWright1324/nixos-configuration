{ pkgs, ... }:
{
  services.minecraft-servers.servers.velocity = {
    enable = true;
    enableReload = true;
    openFirewall = true;
    package = pkgs.velocityServers.velocity;

    symlinks = {
      "plugins/Geyser-Velocity.jar" =
        let
          version = "2.7.0";
          build = "818";
        in
        pkgs.fetchurl {
          pname = "Geyser-Velocity";
          version = "${version}-${build}";
          url = "https://download.geysermc.org/v2/projects/geyser/versions/${version}/builds/${build}/downloads/velocity";
          hash = "sha256-OeLEVXiAKMJkxXptZxWJ026mSJun/s2OgvglEXpLDQ8=";
        };
      "plugins/fllodgate-velocity.jar" =
        let
          version = "2.2.4";
          build = "116";
        in
        pkgs.fetchurl {
          pname = "floodgate-velocity";
          version = "${version}-${build}";
          url = "https://download.geysermc.org/v2/projects/floodgate/versions/${version}/builds/${build}/downloads/velocity";
          hash = "sha256-fq9Vw3A4DWyPaL4+k8XPpBw1EcQyXzmi/4P5dg+hNmo=";
        };
      "velocity.toml" = ./velocity.toml;
    };
  };

  networking.firewall.allowedUDPPorts = [ 19132 ];
}
