{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ../../modules/locale.nix
    ../../modules/fastBoot.nix
    ../../modules/scripts.nix
    ./secrets
    ./services
  ];

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "aarch64-linux";
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 2d";
    };
  };

  users = {
    mutableUsers = false;

    users = {
      root = {
        hashedPasswordFile = config.age.secrets.hashedPassword.path;
      };

      alexw = {
        isNormalUser = true;
        description = "Alex Wright";
        hashedPasswordFile = config.age.secrets.hashedPassword.path;

        extraGroups = [
          "wheel"
        ];

        openssh.authorizedKeys.keys = [
          (builtins.readFile ../../strings/ssh/alexw.txt)
        ];
      };

    };
  };

  boot = {
    initrd.kernelModules = [
      "vc4"
      "bcm2835_dma"
      "i2c_bcm2835"
    ];

    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };

    # GPU memory split
    # kernelParams = [ "cma=320M" ];

    extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom=GB
    '';
  };

  hardware = {
    enableAllFirmware = true;
  };

  services = {
    openssh.enable = true;
  };

  programs = {
    git.enable = true;
  };

  environment.systemPackages = with pkgs; [
    libraspberrypi
    htop
    wget
    p7zip
    unrar
  ];

  security.sudo.wheelNeedsPassword = false;

  networking = {
    hostName = "aquila";
    firewall.enable = false;
    networkmanager = {
      enable = true;

      /*
        ensureProfiles = {
          environmentFiles = [
            config.age.secrets.tshotc.path
          ];

          profiles = {
            tshotc = {
              connection = {
                id = "TSHOTC";
                type = "wifi";
              };

              ipv4 = {
                method = "auto";
              };

              wifi = {
                mode = "infrastructure";
                ssid = "The Scruffy House on the Corner";
              };

              wifi-security = {
                key-mgmt = "wpa-psk";
                pask = "712-AEA-9EC1";
                #psk = "$tshotc";
              };
            };
          };
        };
      */
    };
  };

  zramSwap.enable = true;

  system.stateVersion = "25.05"; # DO NOT TOUCH!
}
