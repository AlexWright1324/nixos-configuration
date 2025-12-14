{ pkgs, lib, ... }:
{
  services = {
    home-assistant = {
      enable = true;
      # extraPackages = python3Packages: with python3Packages; [ ];

      extraComponents = [
        "default_config"
        "mqtt"
        "upnp"
        "androidtv_remote"
        "homekit_controller"
        "braviatv"
        "kegtron"
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
        "openai_conversation"
        "google_assistant"
        "wyoming"
        "whisper"
        "wake_word"
        "ollama"

        # Onboarding
        "analytics"
        "google_translate"
        "met"
        "radio_browser"
        "shopping_list"

        "isal" # Intelligent Storage Acceleration
      ];

      customComponents = with pkgs.home-assistant-custom-components; [
        spook
        moonraker
        octopus_energy
        linksys_velop
      ];

      config = {
        default_config = { };
        frontend.themes = "!include_dir_merge_named themes";
        automation = "!include automations.yaml";
        script = "!include scripts.yaml";
        scene = "!include scenes.yaml";

        http = {
          use_x_forwarded_for = true;
          trusted_proxies = [ "::1" ];
        };

        google_assistant = {
          project_id = "home-assistant-alexjameswright";
          service_account = "!include SERVICE_ACCOUNT.json"; # FIXME make secure and declarative with agenix
          report_state = true;
        };

        media_player = [
          {
            platform = "universal";
            name = "Sony TV";
            unique_id = "sony_tv_combined";
            device_class = "tv";

            children = [
              "media_player.bravia_xr_55a80j"
              "media_player.sony_xr_55a80j"
            ];

            active_child_template = ''
              {% if state_attr('media_player.bravia_xr_55a80j', 'media_content_id') %}
                 media_player.bravia_xr_55a80j
              {% endif %}
            '';

            attributes = {
              source = "media_player.bravia_xr_55a80j|source";
              source_list = "media_player.bravia_xr_55a80j|source_list";
            };

            browse_media_entity = "media_player.bravia_xr_55a80j";

            commands = {
              turn_off = {
                action = "media_player.turn_off";
                data.entity_id = "media_player.bravia_xr_55a80j";
              };

              turn_on = {
                action = "media_player.turn_on";
                data.entity_id = "media_player.bravia_xr_55a80j";
              };

              select_source = {
                action = "media_player.select_source";
                data = {
                  entity_id = "media_player.bravia_xr_55a80j";
                  source = ''{{ source }}'';
                };
              };

              media_play = {
                action = "media_player.media_play";
                target.entity_id = "media_player.bravia_xr_55a80j";
              };

              media_pause = {
                action = "media_player.media_pause";
                target.entity_id = "media_player.bravia_xr_55a80j";
              };

              media_play_pause = {
                action = "media_player.media_play_pause";
                target.entity_id = "media_player.bravia_xr_55a80j";
              };

              media_previous_track = {
                action = "media_player.media_previous_track";
                target.entity_id = "media_player.bravia_xr_55a80j";
              };

              media_next_track = {
                action = "media_player.media_next_track";
                target.entity_id = "media_player.bravia_xr_55a80j";
              };
            };
          }
        ];
      };
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
        availability = true;
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

    wyoming = {
      piper.servers.default = {
        enable = true;
        voice = "en_GB-cori-high";
        uri = "tcp://localhost:10200"; # TODO: Unix socket
      };
      faster-whisper.servers.default = {
        enable = true;
        language = "en";
        model = "base.en";
        uri = "tcp://localhost:10300"; # TODO: Unix socket
      };
      openwakeword = {
        enable = true;
        uri = "tcp://localhost:10400"; # TODO: Unix socket
      };
    };
  };

  systemd.services.zigbee2mqtt.preStart = lib.mkForce "";

  networking.firewall.allowedTCPPorts = [
    8123 # Home Assistant
    #1883 # MQTT
    8080 # Zigbee2MQTT
  ];
}
