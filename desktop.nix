{ config, lib, pkgs, ... }:

{
  # AMD
  boot.initrd.kernelModules = [ "amdgpu" ];
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];


  # Nvidia
  hardware.nvidia = {
    open = false;
    nvidiaSettings = true;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau # Remove
      rocmPackages.clr.icd
      amdvlk
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  # X-Server
  services.xserver = {
    enable = true;
    xkb.layout = "gb";
    videoDrivers = [ "nvidia" "amdgpu" ];
  };
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "plasmax11";

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Plasma Configuration
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.libsForQt5.xdg-desktop-portal-kde ];
}