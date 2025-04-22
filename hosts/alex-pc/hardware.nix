{ pkgs, lib, ... }:
{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        edk2-uefi-shell.enable = true;
        windows."11" = {
          efiDeviceHandle = "HD2b";
        };
        consoleMode = "max";
      };
    };

    kernelPackages = pkgs.linuxPackages_cachyos;

    kernelModules = [ "kvm-amd" ];
    kernelParams = [
      # KVM-AMD
      "amd_iommu=on"
      "iommu=pt"

      # AMDGPU
      "amdgpu.ppfeaturemask=0xffffffff"
    ];

    # RTL8821AE WiFi Driver options
    extraModprobeConfig = ''
      options rtl8821ae ips=0 msi=0 aspm=0
    '';

    # Boot parameters for the kernel
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "usbhid"
    ];
  };

  hardware = {
    enableAllFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
    };
    bluetooth.enable = true;
  };

  # HIP Libraries
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

  networking = {
    hostName = "Alex-PC-NixOS";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    firewall.enable = false;
  };
}
