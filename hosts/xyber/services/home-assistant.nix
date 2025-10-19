{ pkgs, ... }:
{
  services = {
    home-assistant = {
      enable = true;
      extraPackages =
        python3Packages: with python3Packages; [
          aiodiscover
          aiodhcpwatcher
          aiousbwatcher
          async-upnp-client
          av
          go2rtc-client
          pynacl
          paho-mqtt
          pyserial
          getmac
        ];
      extraComponents = [
        "braviatv"
        "cast"
        "upnp"
        "ipp"
        "co2signal"
        "local_calendar"
        "wake_on_lan"
        "spotify"
        "dhcp"
        "zha"
        "ibeacon"

        # Onboarding
        "analytics"
        "google_translate"
        "met"
        "radio_browser"
        "shopping_list"

        "isal" # Intelligent Storage Acceleration
      ];
      customComponents = [
        pkgs.home-assistant-custom-components.spook
      ];
      config = null;
    };

    zigbee2mqtt = {
      enable = true;
      settings = {
        permit_join = true;
        serial = {
          port = "/dev/serial/by-id/usb-Itead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_V2_22658ccb8fc2ef118003c8138148b910-if00-port0";
          adapter = "ember";
        };
        frontend = true;
      };
    };

    mosquitto = {
      enable = true;
      listeners = [
        {
          acl = [ "pattern readwrite #" ];
          omitPasswordAuth = true;
          settings.allow_anonymous = true;
        }
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [
    8123 # Home Assistant
    1883 # MQTT
    8080 # Zigbee2MQTT
  ];
}
