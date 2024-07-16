{
  boot.initrd.systemd.services.systemd-udevd.after = [ "systemd-modules-load.service" ];
  systemd.services.NetworkManager-wait-online.enable = false;
  networking.dhcpcd = {
    wait = "background";
    extraConfig = "noarp";
  };
}