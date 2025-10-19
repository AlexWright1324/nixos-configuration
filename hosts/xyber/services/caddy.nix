{ config, ... }:
{
  services.caddy = {
    enable = true;

    # FIXME: needs DNS setup
    virtualHosts."http://home-assistant.xyber.broadband".extraConfig = ''
      reverse_proxy localhost:8123
    '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
