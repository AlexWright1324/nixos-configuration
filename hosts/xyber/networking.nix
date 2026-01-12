{ config, ... }:
{
  systemd.network = {
    enable = true;
    wait-online.anyInterface = true;

    netdevs = {
      "br-lan" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br-lan";
        };
      };
    };

    networks = {
      "10-br-lan" = {
        matchConfig.Name = "br-lan";
        networkConfig = {
          DHCP = "ipv4";
        };
        dhcpV4Config = {
          RouteMetric = 100;
        };
      };
      "20-ethernet" = {
        matchConfig.Name = "en*";
        networkConfig = {
          Bridge = "br-lan";
        };
      };

      "20-wireless" = {
        matchConfig.Name = "wl*";
        networkConfig = {
          DHCP = "ipv4";
          IgnoreCarrierLoss = "3s";
        };
        dhcpV4Config = {
          RouteMetric = 600;
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
