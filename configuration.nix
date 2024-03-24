{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix # Hardware Scan
    ./desktop.nix                # Desktop Configuration
    ./users.nix                  # Users configuration
    ./packages.nix               # Packages
    ./nix-alien.nix              # nix-alien
    ./scripts.nix                # Import scripts folder
  ];
    
  # Nix Options
  nixpkgs.config.allowUnfree = true;
  nix.settings.system-features = [ "gccarch-znver3" ];
  nixpkgs.hostPlatform = {
    gcc.arch = "znver3";
    gcc.tune = "znver3";
    system = "x86_64-linux";
  };

  nix.gc.automatic = true;
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = "nix-command flakes";
  # Boot Configuration
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.systemd-boot.enable = true;
  boot.kernelParams = [
    "pcie_aspm=off"
    "amd_iommu=on"
    "iommu=pt"
    "kvm.ignore_msrs=1"
    "kvm.report_ignored_msrs=0"
  ];

  boot.supportedFilesystems = [ "btrfs" "ntfs" ];
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
    "/mnt/share" = {
      device = "/dev/disk/by-uuid/aad5f079-9fec-46b4-9c83-72c125f266fa";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=@share" ];
    };
    "/mnt/StorageV3" = {
      device = "/dev/disk/by-uuid/fbc39773-6169-48cf-a5ac-eeb9e8b8bea0";
      fsType = "btrfs";
      options = [ "compress=zstd" ];
    };
  };


  # --- System configuration ---
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    useXkbConfig = true;
  };

  # Networking
  networking.hostName = "Alex-PC-NixOS";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  # ZRAM generator
  zramSwap.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

