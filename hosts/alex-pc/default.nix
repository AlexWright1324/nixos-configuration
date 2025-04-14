{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./filesystem.nix # Filesystem Configuration
    ./desktop.nix # Desktop Configuration
    ./users.nix # Users configuration
    ./packages.nix # Packages
    ../../modules/scripts.nix # Scripts
    ../../modules/fastBoot.nix # Fast Boot
  ];

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "x86_64-linux";
  };

  nix = {
    settings.experimental-features = "nix-command flakes";
    settings.auto-optimise-store = true;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = false;
      systemd-boot.enable = true;
    };

    kernelPackages = pkgs.linuxPackages_cachyos;
    supportedFilesystems = [
      "btrfs"
      "ntfs"
    ];
    kernelModules = [ "kvm-amd" ];
    kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
      "amdgpu.ppfeaturemask=0xffffffff"
    ];
    extraModprobeConfig = ''
      options rtl8821ae ips=0 msi=0 aspm=0
    '';

    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "usbhid"
    ];
  };

  hardware.enableAllFirmware = true;

  # Localisation
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";

  networking = {
    hostName = "Alex-PC-NixOS";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    firewall.enable = false;
  };

  # ZRAM generator
  zramSwap.enable = true;

  # Limits.conf
  security.pam.loginLimits = [
    {
      domain = "*";
      item = "nofile";
      type = "hard";
      value = "65535";
    }
    {
      domain = "*";
      item = "nofile";
      type = "soft";
      value = "8192";
    }
  ];

  # DO NOT EDIT
  system.stateVersion = "23.11";
}
