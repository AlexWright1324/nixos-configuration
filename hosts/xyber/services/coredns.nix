{ pkgs, ... }:
{
  services = {
    resolved.extraConfig = ''
      DNSStubListener=no
    '';

    coredns = {
      enable = true;
      package = (
        pkgs.coredns.override {
          externalPlugins = [
            {
              name = "blocklist";
              repo = "github.com/relekang/coredns-blocklist";
              version = "v1.13.0";
            }
          ];
          vendorHash = "sha256-ttCuaotPbRwmZOze0FBYmwBqG4gmfBtNs5VOQ70/ZaM=";
        }
      );
      config = ''
        . {
          errors
          metadata
          # prometheus

          blocklist https://big.oisd.nl {
            bootstrap_dns 9.9.9.9:53
          }

          cache

          forward . tls://[2620:fe::fe]:853 tls://9.9.9.9:853 {
            tls_servername dns.quad9.net
            health_check 15s
          }
        }
      '';
    };
  };

  networking.firewall = {
    allowedUDPPorts = [ 53 ];
    allowedTCPPorts = [ 53 ];
  };
}
