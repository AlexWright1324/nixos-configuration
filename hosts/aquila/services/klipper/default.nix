{
  services.klipper = {
    enable = true;
    user = "moonraker";
    group = "moonraker";

    firmwares = {
      mcu = {
        enable = true;
        enableKlipperFlash = true;
        # > nix-shell -p klipper-genconf --command klipper-genconf
        configFile = ./config;
      };
    };

    mutableConfig = true;
    configDir = "/var/lib/moonraker/config";

    # https://github.com/Klipper3d/klipper/blob/master/config/printer-voxelab-aquila-2021.cfg
    settings = {
      mcu = {
        serial = "/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0";
        restart_method = "command";
      };
    };
  };
}
