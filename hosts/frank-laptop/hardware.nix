{ pkgs, lib, ... }:
{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    #kernelPackages = pkgs.linuxPackages_cachyos;
    supportedFilesystems = [
      "btrfs"
      "ntfs"
    ];

    kernelModules = [ "kvm-amd" ];
    kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
    ];

    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ums_realtek"
      "usb_storage"
      "usbhid"
    ];

  };

  hardware = {
    enableAllFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      /*
        extraPackages = with pkgs; [
             rocmPackages.clr.icd
           ];
      */
    };
    bluetooth.enable = true;
  };

  # HIP Libraries
  /*
    systemd.tmpfiles.rules =
     let
       rocmEnv = pkgs.symlinkJoin {
         name = "rocm-combined";
         paths = with pkgs.rocmPackages; [
           rocblas
           hipblas
           clr
         ];
       };
     in
     [
       "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
     ];
  */

  networking = {
    hostName = "Frank-Laptop-NixOS";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    firewall.enable = false;
  };
}
