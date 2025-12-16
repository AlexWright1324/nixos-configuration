{ config, ... }:
{
  boot.kernel.sysctl = {
    # IPv4/IPv6 forwarding
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.all.autoconf" = 0;
    "net.ipv6.conf.all.use_tempaddr" = 0;
    "net.ipv6.conf.all.proxy_ndp" = 1;
  };

  networking = {
    hostName = "xyber";

    # SystemD handles this instead
    useDHCP = false;
    firewall.enable = false;
    nat.enable = false;

    extraHosts = ''
      192.168.1.1 xyber.local
    '';

    nftables = {
      enable = true;
      ruleset =
        let
          #TODO: local firewall ports
          tcp = config.networking.firewall.allowedTCPPorts;
          udp = config.networking.firewall.allowedUDPPorts;
        in
        ''
          table inet filter {
            chain input {
              type filter hook input priority 0;
              policy drop;

              iifname "lo" accept comment "Allow all loopback traffic"
              iifname "lan" accept comment "Allow all LAN traffic"
              
              iifname "wan" ct state { established, related } accept comment "Allow established/related internet traffic"
              iifname "wan" icmp type { echo-request, destination-unreachable, time-exceeded } accept comment "Allow select ICMP internet traffic"
              iifname "wan" icmpv6 type { nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert, nd-redirect } accept comment "Allow IPv6 neighbour discovery"
              iifname "wan" udp dport dhcpv6-client udp sport dhcpv6-server counter accept comment "Allow DHCPv6"
              iifname "wan" counter drop comment "Drop all other unsolicited internet traffic"
            }

            chain forward {
              type filter hook forward priority 0;
              policy drop;

              iifname "lan" oifname "wan" accept comment "Allow trusted LAN to Internet"
              iifname "wan" oifname "lan" ct state { established, related } accept comment "Allow established/related Internet to LAN"
              iifname "wan" oifname "lan" ct status dnat accept comment "Allow DNATed Internet to LAN"
            }
          }

          table ip nat {
            chain postrouting {
              type nat hook postrouting priority 100;
              policy accept;
              oifname "wan" masquerade
            }
          }
        '';
    };
  };

  systemd.network = {
    enable = true;
    wait-online.enable = false;
    links = {
      "10-lan" = {
        matchConfig.MACAddress = "e0:51:d8:1b:35:8f";
        linkConfig.Name = "lan";
      };
      "20-wan" = {
        matchConfig.MACAddress = "e0:51:d8:1b:35:90";
        linkConfig.Name = "wan";
      };
    };

    networks = {
      "10-lan" =
        let
          v4dns = [
            "9.9.9.9"
            "1.1.1.1"
          ];
          v6dns = [
            "2620:fe::fe"
            "2606:4700:4700::1111"
          ];
          dns = v6dns ++ v4dns;
        in
        {
          matchConfig.Name = "lan";
          address = [
            "192.168.1.1/24"
          ];
          dns = dns;
          domains = [ "local" ];

          networkConfig = {
            DHCPServer = true;
            IPv6SendRA = true;
            IPv6AcceptRA = false;
            DHCPPrefixDelegation = true;
          };

          dhcpServerConfig = {
            PoolOffset = 10;
            PoolSize = 245;
            EmitDNS = true;
            DNS = v4dns;
          };

          ipv6SendRAConfig = {
            EmitDNS = true;
            DNS = v6dns;
          };

          dhcpPrefixDelegationConfig = {
            UplinkInterface = "wan";
            SubnetId = "0x1";
            Announce = true;
          };

          linkConfig = {
            RequiredForOnline = "carrier";
          };
        };

      "20-wan" = {
        matchConfig.Name = "wan";

        networkConfig = {
          DHCP = "yes";

          IPv6AcceptRA = true;
          IPv6PrivacyExtensions = false;
          DHCPPrefixDelegation = true;
          # KeepConfiguration = true;

          DNSOverTLS = true;
          DNSSEC = true;
        };

        dhcpV6Config = {
          WithoutRA = "solicit";
          PrefixDelegationHint = "::/56";
        };

        dhcpPrefixDelegationConfig = {
          UplinkInterface = ":self";
          SubnetId = "0x0";
          Announce = false;
        };

        linkConfig = {
          RequiredForOnline = "routable";
        };
      };
    };
  };
}
