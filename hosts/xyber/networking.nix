{ config, ... }:
{
  systemd.network = {
    enable = true;
    wait-online.anyInterface = true;
    networks = {
      "50-wired" = {
        matchConfig.Name = "en*";
        networkConfig = {
          DHCP = true;
        };
      };

      "50-wireless" = {
        matchConfig.Name = "wl*";
        networkConfig = {
          DHCP = true;
          IgnoreCarrierLoss = "3s";
        };
      };
    };
  };

  networking = {
    hostName = "xyber";
    wireless = {
      enable = true;
      secretsFile = config.age.secrets.tshotc.path;
      networks = {
        "The Scruffy House on the Corner" = {
          pskRaw = "ext:tshotc";
        };
      };
    };

    useDHCP = false;
  };
}
