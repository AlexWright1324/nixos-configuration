{
  config,
  inputs,
  pkgs,
  ...
}:

let
  website = inputs.website.outputs.packages.${pkgs.system}.default;

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
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
      hash = "sha256-j+xUy8OAjEo+bdMOkQ1kVqDnEkzKGTBIbMDVL7YDwDY=";
    };

    virtualHosts."alexjameswright.net".extraConfig = ''
      root * ${website}
      file_server
    ''
    + cloudflare;

    virtualHosts."go.alexjameswright.net".extraConfig = ''
      handle /hostacoffee {
        redir https://alexjameswright.net/hostacoffeemanual.pdf
      }

      respond "Not found" 404
    ''
    + cloudflare;

    virtualHosts."*.alexjameswright.net".extraConfig = ''
      redir https://alexjameswright.net{uri}
    ''
    + cloudflare;

    environmentFile = config.age.secrets.caddyEnvironmentFile.path;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
