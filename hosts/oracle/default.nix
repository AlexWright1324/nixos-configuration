{
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./filesystem.nix
    ./packages.nix
    ./shackbot.nix
    ./users.nix
    ./minecraft
    ./website
    ./secrets
    ../../modules/locale.nix
    ../../modules/fastBoot.nix
    ../../modules/scripts.nix
  ];

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
      options = "--delete-older-than 10d";
    };
  };

  boot = {
    initrd.availableKernelModules = [ "virtio_scsi" ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        efiSupport = true;
        device = "nodev";
      };
    };
  };

  hardware = {
    enableAllFirmware = true;
  };

  networking = {
    hostName = "oracle";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };

  zramSwap.enable = true;

  # nixos-rebuild switch --flake .#oracle --target-host oracle --build-host oracle --no-reexec --sudo --ask-sudo-password

  system.stateVersion = "25.05"; # DO NOT TOUCH!
}
