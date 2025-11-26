{
  config,
  pkgs,
  ...
}:

let
  cloudflare = ''
    tls {
      dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
  '';
in
{
  services.caddy = {
    enable = true;

    package = pkgs.caddy.withPlugins {
      # https://github.com/caddy-dns/cloudflare
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.2" ];
      hash = "sha256-ea8PC/+SlPRdEVVF/I3c1CBprlVp1nrumKM5cMwJJ3U=";
    };

    virtualHosts = {
      "home-assistant.alexjameswright.net".extraConfig = ''
        reverse_proxy localhost:8123
      ''
      + cloudflare;
      "immich.alexjameswright.net".extraConfig = ''
        reverse_proxy localhost:2283
      ''
      + cloudflare;
      "vaultwarden.alexjameswright.net".extraConfig = ''
        reverse_proxy unix//run/vaultwarden/vaultwarden.sock
      ''
      + cloudflare;
    };

    environmentFile = config.age.secrets.caddyEnvironmentFile.path;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
