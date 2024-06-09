{ config, lib, pkgs, ... }:

{
  # AMD
  boot.initrd.kernelModules = [ "amdgpu" ];
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      #amdvlk
    ];
    extraPackages32 = with pkgs; [
      #driversi686Linux.amdvlk
    ];
  };

  # X-Server
  services.xserver = {
    enable = true;
    xkb.layout = "gb";
    videoDrivers = [ "amdgpu" ];
  };
  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
    defaultSession = "plasma";
  };
  services.desktopManager.plasma6.enable = true;


  # Bluetooth
  hardware.bluetooth.enable = true;

  # Plasma Configuration
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.extraConfig = {
      alsa_monitor.rules = {
        {
          matches = {{{ "node.name" "matches" "alsa_output.pci-0000_0b_00.4.analog-surround-51" }}};
          apply_properties = {
            ["audio.positions"] = "FL,FR,FL,FR,FC,LFE";
          };
        };
      };
    };
  };
}