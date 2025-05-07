{ config, pkgs, ... }:
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
      "plugins/floodgate-velocity.jar" =
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
      "plugins/voicechat-velocity.jar" = pkgs.fetchurl {
        pname = "voicechat-velocity";
        version = "2.5.30";
        url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/gN7gtGyZ/voicechat-velocity-2.5.30.jar";
        hash = "sha256-PTIOsH6OvbxaOPZxFD8hjnRr80VdLj+Xcx9PnWwdGSI=";
      };
      "velocity.toml" = ./velocity.toml;
      "forwarding.secret" = config.age.secrets.forwardingSecret.path;
    };
  };

  networking.firewall.allowedUDPPorts = [
    25565
    19132
  ];
}
