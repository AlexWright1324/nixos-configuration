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
          vendorHash = "sha256-UYZgMTdT1UCMPoDUc9UV0sWinzKsdIrDX0EN2jiGdyQ=";
        }
      );
      config = ''
        . {
          errors
          metadata
          # prometheus

          hosts /etc/coredns/hosts {
            fallthrough
          }

          blocklist https://big.oisd.nl {
            bootstrap_dns 9.9.9.9:53
          }

          forward . 9.9.9.9 149.112.112.112 # Quad9
        }
      '';
    };
  };

  environment.etc."coredns/hosts".text = ''
    192.168.1.2 home-assistant.alexjameswright.net immich.alexjameswright.net
  '';

  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}
