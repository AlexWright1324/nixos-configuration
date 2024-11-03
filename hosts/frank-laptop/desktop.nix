{ pkgs, ... }:

{
  # AMD
  hardware.amdgpu = {
    initrd.enable = true;
  };

  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
    defaultSession = "plasma";
  };

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Plasma
  environment.systemPackages = with pkgs; [
    qt6.qtimageformats # WebP Support
    kdePackages.krfb
    kdePackages.k3b
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
  };
}
