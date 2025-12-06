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

          #template IN A home-assistant.alexjameswright.net immich.alexjameswright.net {
          #  answer "{{ .Name }} 60 IN CNAME xyber-3.broadband"
          #}

          blocklist https://big.oisd.nl {
            bootstrap_dns 1.1.1.1:53
          }

          forward . 1.1.1.1 1.0.0.1
        }
      '';
    };
  };

  networking.firewall = {
    allowedUDPPorts = [ 53 ];
    allowedTCPPorts = [ 53 ];
  };
}
