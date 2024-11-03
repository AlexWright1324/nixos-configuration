{ config, ... }:
{
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  # - In home manager
  #environment.systemPackages = with pkgs; [
  #  droidcam
  #];
}
