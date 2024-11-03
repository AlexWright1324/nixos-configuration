{ pkgs, ... }:

{
  # AMD
  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
  };
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

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

  services.dbus.implementation = "broker";

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Plasma
  environment.systemPackages = with pkgs; [
    qt6.qtimageformats # WebP Support
  ];
  services.desktopManager.plasma6.enable = true;
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
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "link.max-buffers" = 128;
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 2048;
        "default.clock.min-quantum" = 1024;
        "default.clock.max-quantum" = 4096;
      };
    };
  };
}
