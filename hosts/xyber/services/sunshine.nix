{ pkgs, ... }:
{
  services = {
    sunshine = {
      enable = true;
      capSysAdmin = true;
      openFirewall = true;
      settings = {
        # port = 47989;
        sunshine_name = "Xyber";
      };
      applications = {
        env = {

        };
        apps = [
          {
            name = "Desktop";
            auto-detach = true;
            prep-cmds = [
              {
                do = "${pkgs.ydotool}/bin/ydotool click 0xC1";
              }
            ];
          }
        ];
      };
    };

    displayManager = {
      sddm = {
        enable = true;
        settings = {
          General.HaltCommand = false;
          General.RebootCommand = false;
        };
      };
      autoLogin.enable = true;
      autoLogin.user = "alexw";
    };

    desktopManager = {
      plasma6.enable = true;
    };

    dbus.implementation = "broker";

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  hardware = {
    uinput.enable = true;
    display = {
      outputs = {
        "HDMI-A-1" = {
          edid = "TV.bin";
          mode = "e";
        };
      };
      edid = {
        linuxhw = {
          TV = [
            "SNY7105"
            "3840x2160"
            "55.0"
            "2021"
          ];
        };
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
    ];
  };

  programs.ydotool.enable = true;

  security.rtkit.enable = true;

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };
}
