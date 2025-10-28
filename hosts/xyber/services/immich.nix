{ pkgs, ... }:
{
  services = {
    immich = {
      enable = true;
      port = 2283;
      host = "0.0.0.0";
      openFirewall = true;
      mediaLocation = "/storage/immich";
      accelerationDevices = [ "/dev/dri/renderD128" ];
    };
  };

  users.users.immich.extraGroups = [
    "video"
    "render"
  ];

  environment.systemPackages = with pkgs; [
    immich-cli
  ];
}
