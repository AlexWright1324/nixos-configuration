{
  fileSystems = {
    # Main Drive
    "/" = {
      device = "/dev/disk/by-uuid/aad5f079-9fec-46b4-9c83-72c125f266fa";
      fsType = "btrfs";
      options = [ "subvol=@nixos-root" "compress=zstd" ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/aad5f079-9fec-46b4-9c83-72c125f266fa";
      fsType = "btrfs";
      options = [ "subvol=@nixos-home" "compress=zstd" ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/aad5f079-9fec-46b4-9c83-72c125f266fa";
      fsType = "btrfs";
      options = [ "subvol=@nixos-nix" "compress=zstd" "noatime" ];
    };
    "/boot" = { 
      device = "/dev/disk/by-uuid/4D2C-9454";
      fsType = "vfat";
    };
    "/mnt/share" = {
      device = "/dev/disk/by-uuid/aad5f079-9fec-46b4-9c83-72c125f266fa";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=@share" ];
    };

    # Others
    "/mnt/StorageV3" = {
      device = "/dev/disk/by-uuid/fbc39773-6169-48cf-a5ac-eeb9e8b8bea0";
      fsType = "btrfs";
      options = [ "compress=zstd" "nofail" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
    };
  };
}