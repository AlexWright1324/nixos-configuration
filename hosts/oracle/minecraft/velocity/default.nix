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
          version = "2.9.2";
          build = "1014";
        in
        pkgs.fetchurl {
          pname = "Geyser-Velocity";
          version = "${version}-${build}";
          url = "https://download.geysermc.org/v2/projects/geyser/versions/${version}/builds/${build}/downloads/velocity";
          hash = "sha256-+kQvWw4nw/PJrUxWShqvOvB/s4UoJexZJj30MAuidT0=";
        };
      "plugins/floodgate-velocity.jar" =
        let
          version = "2.2.5";
          build = "125";
        in
        pkgs.fetchurl {
          pname = "floodgate-velocity";
          version = "${version}-${build}";
          url = "https://download.geysermc.org/v2/projects/floodgate/versions/${version}/builds/${build}/downloads/velocity";
          hash = "sha256-auLXbMJmoeM6bi9NYqzwKN0ztz1rjDr7rCbSS1mLUkQ=";
        };
      "plugins/voicechat-velocity.jar" = pkgs.fetchurl {
        pname = "voicechat-velocity";
        version = "2.6.4";
        url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/jMopHMDQ/voicechat-velocity-2.6.4.jar";
        hash = "sha256-ESKaE1kc9xP/Xlciz3tcXz6qf9tZQZY6KPWyI6+VmPA=";
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
