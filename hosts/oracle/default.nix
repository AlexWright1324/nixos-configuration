{ lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./filesystem.nix
    ./packages.nix
    ./users.nix
    ./minecraft
    ../../modules/locale.nix
    ../../modules/fastBoot.nix
    ../../modules/scripts.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "aarch64-linux";
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  boot = {
    initrd.availableKernelModules = [ "virtio_scsi" ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
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

  # nixos-rebuild switch --flake .#oracle --target-host oracle --build-host oracle --fast --use-remote-sudo

  system.stateVersion = "25.05"; # DO NOT TOUCH!
}
