{
  fileSystems = let 
    device = "/dev/disk/by-uuid/aad5f079-9fec-46b4-9c83-72c125f266fa";
    efiDevice = "/dev/disk/by-uuid/4D2C-9454";
  in {
    # Main Drive
    "/" = {
      inherit device;
      fsType = "btrfs";
      options = [ "subvol=@nixos-root" "compress=zstd" ];
    };
    "/home" = {
      inherit device;
      fsType = "btrfs";
      options = [ "subvol=@nixos-home" "compress=zstd" ];
    };
    "/nix" = {
      inherit device;
      fsType = "btrfs";
      options = [ "subvol=@nixos-nix" "compress=zstd" "noatime" ];
    };
    "/boot" = { 
      device = efiDevice;
      fsType = "vfat";
    };

    # Others
  };
}