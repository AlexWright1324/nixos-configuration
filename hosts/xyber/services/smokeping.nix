{ config, ... }:
{
  services = {
    smokeping = {
      enable = true;
      webService = false;
      hostName = "192.168.1.2";

      targetConfig = ''
        probe = FPing
        menu = Top
        title = Network Latency Monitor

        + Internet
        menu = Internet Targets
        title = Public DNS and Services

        ++ Cloudflare
        menu = Cloudflare DNS
        title = Cloudflare 1.1.1.1
        host = 1.1.1.1

        ++ Quad9
        menu = Quad9 DNS
        title = Quad9 9.9.9.9
        host = 9.9.9.9

        ++ Google
        menu = Google DNS
        title = Google 8.8.8.8
        host = 8.8.8.8

        ++ Oracle
        menu = Oracle Cloud Server
        title = play.alexjameswright.net
        host = play.alexjameswright.net
      '';
    };

    fcgiwrap.instances.smokeping = {
      process.user = config.services.smokeping.user;
      process.group = config.services.smokeping.user;
      socket = { inherit (config.services.caddy) user group; };
    };

    caddy.virtualHosts.":8081".extraConfig =
      let
        smokepingHome = config.users.users.${config.services.smokeping.user}.home;
      in
      ''
        root * ${smokepingHome}
        file_server

        @fcgi {
          path /smokeping.fcgi
        }

        route @fcgi {
          reverse_proxy unix${config.services.fcgiwrap.instances.smokeping.socket.address} {
            transport fastcgi {
              env SCRIPT_FILENAME ${smokepingHome}/smokeping.fcgi
              split ""
            }
        }
      '';
    #${config.services.fcgiwrap.instances.smokeping.socket.address}
  };

  users.users.${config.services.caddy.user}.extraGroups = [
    config.services.smokeping.user
  ];

  networking.firewall.allowedTCPPorts = [
    8081
  ];
}
