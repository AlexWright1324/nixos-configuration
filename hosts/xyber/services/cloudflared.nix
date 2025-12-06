{ config, ... }:
{
  services.cloudflared = {
    enable = true;
    certificateFile = config.age.secrets.cloudflared.path;
    tunnels = {
      "7fcde78f-0823-4bdd-9ab8-e68a645aaa37" = {
        credentialsFile = config.age.secrets.cloudflared-home-assistant.path;
        default = "http_status:404";
        ingress = {
          "*.alexjameswright.net" = {
            service = "https://localhost:443";
            originRequest.originServerName = "*.alexjameswright.net";
          };
        };
      };
    };
  };
}
