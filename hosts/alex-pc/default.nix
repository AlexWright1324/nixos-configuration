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
    ./scripts.nix # Import scripts folder
    ../../modules/fastBoot.nix # Fast Boot
  ];

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "x86_64-linux";
  };

  nix = {
    settings.auto-optimise-store = true;
    settings.experimental-features = "nix-command flakes";

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
      "kvm.ignore_msrs=1"
      "kvm.report_ignored_msrs=0"
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

  chaotic.scx.enable = true;
  chaotic.scx.scheduler = "scx_bpfland";

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
