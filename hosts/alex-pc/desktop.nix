{ pkgs, ... }:

{
  # AMD
  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [ rocmPackages.clr.icd ];
    };
    bluetooth.enable = true;
  };

  systemd.tmpfiles.rules =
    let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          rocblas
          hipblas
          clr
        ];
      };
    in
    [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];

  services = {
    xserver = {
      enable = true;
      xkb.layout = "gb";
      videoDrivers = [ "amdgpu" ];
    };
    displayManager = {
      sddm.enable = true;
      sddm.wayland.enable = true;
      #cosmic-greeter.enable = true;
      defaultSession = "plasma";
    };
    desktopManager = {
      plasma6.enable = true;
      #cosmic.enable = true;
    };
    dbus.implementation = "broker";
    pipewire = {
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
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  environment.systemPackages = with pkgs; [
    qt6.qtimageformats # WebP Support
  ];

  # Audio
  security.rtkit.enable = true;
}
