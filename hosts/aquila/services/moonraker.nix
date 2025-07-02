{ config, ... }:
{
  services.moonraker = {
    enable = true;
    address = "0.0.0.0";
    allowSystemControl = true;
    settings = {
      authorization = {
        trusted_clients = [
          "10.0.0.0/8"
          "127.0.0.0/8"
          "169.254.0.0/16"
          "172.16.0.0/12"
          "192.168.0.0/16"
          "FE80::/10"
          "::1/128"
        ];
        cors_domains = [
          "*.local"
          "*://my.mainsail.xyz"
          "*://app.fluidd.xyz"
          "*://${config.networking.hostName}"
        ];
      };
    };
  };
}
