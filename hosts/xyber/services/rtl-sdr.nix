{ config, ... }:
let
  port = 1234;
in
{
  hardware.rtl-sdr.enable = true;
  systemd.services.rtl-tcp = {
    enable = true;

    serviceConfig = {
      ExecStart = "${config.hardware.rtl-sdr.package}/bin/rtl_tcp -a 0.0.0.0 -p ${toString port}";
      Restart = "on-failure";
    };

    unitConfig = {
      StopWhenUnneeded = true;
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2838", TAG+="systemd", ENV{SYSTEMD_WANTS}+="rtl-tcp.service"
  '';

  networking.firewall.allowedTCPPorts = [ port ];
}
