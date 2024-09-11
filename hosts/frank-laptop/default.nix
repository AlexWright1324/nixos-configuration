{ lib, pkgs, ... }:

{
  imports = [
    ./desktop.nix           # Desktop Configuration
    ./filesystem.nix        # Filesystem Configuration
    ./packages.nix          # Packages
    ./users.nix             # Users configuration
    ../../modules/fastBoot.nix  # Fast Boot
  ];
  
  nixpkgs = {
    config.allowUnfree = true;
  };

  nix = {
    settings.auto-optimise-store = true;
    settings.experimental-features = "nix-command flakes";
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    #kernelPackages = pkgs.linuxPackages_cachyos;
    supportedFilesystems = [ "btrfs" "ntfs" ];
    kernelModules = [ "kvm-amd" ];
    kernelParams = [ "amd_iommu=on" "iommu=pt" ];
    
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ums_realtek" "usb_storage" "usbhid" ];

  };
  
  hardware.enableAllFirmware = true;

  # Localisation
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";

  networking = {
    hostName = "Frank-Laptop-NixOS";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    firewall.enable = false;
  };

  # ZRAM generator
  zramSwap.enable = true;

  # Limits.conf
  security.pam.loginLimits = [
    { domain = "*"; item = "nofile"; type = "hard"; value = "65535"; }
    { domain = "*"; item = "nofile"; type = "soft"; value = "8192"; }
  ];

  # DO NOT EDIT
  system.stateVersion = "23.11";
}

