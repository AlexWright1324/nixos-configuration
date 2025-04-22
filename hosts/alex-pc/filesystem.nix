{
  boot.supportedFilesystems = [
    "btrfs"
    "ntfs"
  ];

  fileSystems =
    let
      MainSSDBoot = "/dev/disk/by-uuid/4D2C-9454";
      MainSSDBtrfs = "/dev/disk/by-uuid/aad5f079-9fec-46b4-9c83-72c125f266fa";
      StorageV3 = "/dev/disk/by-uuid/fbc39773-6169-48cf-a5ac-eeb9e8b8bea0";

      btrfsOptions = [
        "compress=zstd"
      ];
    in
    {
      # Main Drive
      "/boot" = {
        device = MainSSDBoot;
        fsType = "vfat";
      };
      "/" = {
        device = MainSSDBtrfs;
        fsType = "btrfs";
        options = [
          "subvol=@nixos-root"
        ] ++ btrfsOptions;
      };
      "/home" = {
        device = MainSSDBtrfs;
        fsType = "btrfs";
        options = [
          "subvol=@nixos-home"
        ] ++ btrfsOptions;
      };
      "/nix" = {
        device = MainSSDBtrfs;
        fsType = "btrfs";
        options = [
          "subvol=@nixos-nix"
          "noatime"
        ] ++ btrfsOptions;
      };
      "/mnt/share" = {
        device = MainSSDBtrfs;
        fsType = "btrfs";
        options = [
          "subvol=@share"
        ] ++ btrfsOptions;
      };

      # Others
      "/mnt/StorageV3" = {
        device = StorageV3;
        fsType = "btrfs";
        options = [
          "nofail"
          "noauto"
          "x-systemd.automount"
          "x-systemd.idle-timeout=600"
        ] ++ btrfsOptions;
      };
    };
}
