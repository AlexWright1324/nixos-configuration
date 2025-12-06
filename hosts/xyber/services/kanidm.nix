{ config, pkgs, ... }:
let
  domain = "auth.alexjameswright.net";
  tlsPath = "${config.services.caddy.dataDir}/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/wildcard_.alexjameswright.net/wildcard_.alexjameswright.net";
in
{
  services.kanidm = {
    enableServer = true;
    package = pkgs.kanidm_1_8;
    serverSettings = {
      inherit domain;
      origin = "https://${domain}/";
      # bindaddress = "127.0.0.1:8443";

      tls_chain = "${tlsPath}.crt";
      tls_key = "${tlsPath}.key";
    };
  };

  systemd = {
    paths."kanidm-cert-watch" = {
      wantedBy = [ "multi-user.target" ];
      pathConfig = {
        PathChanged = "${tlsPath}.crt";
        Unit = "kanidm.service";
      };
    };
    services.kanidm = {
      reloadTriggers = [ "kanidm-cert-watch.path" ];
      serviceConfig = {
        # After = [ "caddy.service" ];
        # FIXME: Cant determine when certs are ready, so just always restart on change
        After = [ "kanidm-cert-watch.path" ];
      };
    };
    tmpfiles.rules = [
      # Allow directory traversal to Kanidm
      "A ${config.services.caddy.dataDir} - - - - u:kanidm:rx"
      "A ${config.services.caddy.dataDir}/.local - - - - u:kanidm:rx"
      "A ${config.services.caddy.dataDir}/.local/share - - - - u:kanidm:rx"
      "A ${config.services.caddy.dataDir}/.local/share/caddy - - - - u:kanidm:rx"
      "A ${config.services.caddy.dataDir}/.local/share/caddy/certificates - - - - u:kanidm:rx"
      "A ${config.services.caddy.dataDir}/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory - - - - u:kanidm:rx"
      "A ${config.services.caddy.dataDir}/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/wildcard_.alexjameswright.net - - - - u:kanidm:rx"

      # Give Kanidm read access to the actual cert + key
      "A ${tlsPath}/wildcard_.alexjameswright.net.crt - - - - u:kanidm:rx"
      "A ${tlsPath}/wildcard_.alexjameswright.net.key - - - - u:kanidm:r"
    ];
  };
}
