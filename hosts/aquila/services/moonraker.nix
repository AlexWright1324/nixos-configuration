{ config, pkgs, ... }:
{
  services.moonraker = {
    enable = true;
    address = "0.0.0.0";
    allowSystemControl = true;
    settings = {
      authorization = {
        trusted_clients = [
          "10.0.0.0/8"
          "127.0.0.0/8"
          "169.254.0.0/16"
          "172.16.0.0/12"
          "192.168.0.0/16"
          "FE80::/10"
          "::1/128"
        ];
        cors_domains = [
          "*.local"
          "*://my.mainsail.xyz"
          "*://app.fluidd.xyz"
          "*://${config.networking.hostName}"
        ];
      };

      octoprint_compat = { };

      file_manager = {
        enable_object_processing = true;
      };

      announcements = {
        subscriptions = [ "fluidd" ];
      };

      update_manager = {
        enable_auto_refresh = true;
        enable_system_updates = [ false ];
      };

      "update_manager Klipper-Adaptive-Meshing-Purging" = {
        type = "git_repo";
        channel = "dev";
        path = "${config.services.moonraker.stateDir}/config/KAMP";
        origin = "https://github.com/kyleisah/Klipper-Adaptive-Meshing-Purging.git";
        managed_services = [ "klipper" ];
        primary_branch = "main";
      };
    };
  };

  systemd.services.moonraker = {
    path = with pkgs; [ git ];
  };
}
