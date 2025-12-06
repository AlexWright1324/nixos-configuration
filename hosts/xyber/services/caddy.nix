{
  config,
  pkgs,
  ...
}:

{
  services.caddy = {
    enable = true;

    package = pkgs.caddy.withPlugins {
      # https://github.com/caddy-dns/cloudflare
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.2" ];
      hash = "sha256-ea8PC/+SlPRdEVVF/I3c1CBprlVp1nrumKM5cMwJJ3U=";
    };

    virtualHosts = {
      "*.alexjameswright.net".extraConfig = ''
        tls {
          dns cloudflare {env.CLOUDFLARE_API_TOKEN}
        }

        @home-assistant host home-assistant.alexjameswright.net
        handle @home-assistant {
          reverse_proxy localhost:8123
        }

        @immich host immich.alexjameswright.net
        handle @immich {
          reverse_proxy localhost:2283
        }

        @vaultwarden host vaultwarden.alexjameswright.net
        handle @vaultwarden {
          reverse_proxy localhost:8222
          # reverse_proxy unix//run/vaultwarden/vaultwarden.sock
        }

        @auth host auth.alexjameswright.net
        handle @auth {
          reverse_proxy ${config.services.kanidm.provision.instanceUrl} {
            transport http {
              tls
              tls_insecure_skip_verify
            }
          }
        }

        handle {
          abort
        }
      '';
    };

    environmentFile = config.age.secrets.caddyEnvironmentFile.path;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
