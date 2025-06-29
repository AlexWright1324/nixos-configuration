{
  boot.supportedFilesystems = [
    "btrfs"
    "ntfs"
  ];

  fileSystems =
    let
      device = "/dev/disk/by-uuid/6f17ed96-4fd5-4eb6-aff7-dbfc886f4949";
      efiDevice = "/dev/disk/by-uuid/067B-1A09";
    in
    {
      # Main Drive
      "/" = {
        inherit device;
        fsType = "btrfs";
        options = [
          "subvol=@nixos-root"
          "compress=zstd"
        ];
      };
      "/home" = {
        inherit device;
        fsType = "btrfs";
        options = [
          "subvol=@nixos-home"
          "compress=zstd"
        ];
      };
      "/nix" = {
        inherit device;
        fsType = "btrfs";
        options = [
          "subvol=@nixos-nix"
          "compress=zstd"
          "noatime"
        ];
      };
      "/boot" = {
        device = efiDevice;
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
      };

      # Others
      "/mnt/old-home" = {
        inherit device;
        fsType = "btrfs";
        options = [
          "subvol=@home"
          "compress=zstd"
        ];
      };

    };
}
