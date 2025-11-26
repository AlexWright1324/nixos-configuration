{ config, ... }:
{
  services = {
    vaultwarden = {
      enable = true;
      backupDir = "/storage/vaultwarden";

      environmentFile = config.age.secrets.vaultwarden.path;

      config = {
        DOMAIN = "https://vaultwarden.alexjameswright.net";
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = "8222";

        SIGNUPS_ALLOWED = false;

        PUSH_ENABLED = true;
        PUSH_INSTALLATION_ID = "3916a045-b2c9-4835-94fe-b39301709e28";
        PUSH_RELAY_URI = "https://api.bitwarden.eu";
        PUSH_IDENTITY_URI = "https://identity.bitwarden.eu";
      };
    };
  };

  #systemd.services.vaultwarden = {
  #  serviceConfig = {
  #    RuntimeDirectory = "vaultwarden";
  #  };
  #};
}
