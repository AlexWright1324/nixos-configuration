{ ... }:
{
  boot.supportedFilesystems = [ "btrfs" ];

  fileSystems =
    let
      Boot = "/dev/disk/by-uuid/92F2-29B6";
      Main = "/dev/disk/by-uuid/81eaf0a3-244f-4b97-a89b-8e94dd65cd37";

      btrfsOptions = [
        "compress=zstd"
      ];
    in
    {
      # Main Drive
      "/boot" = {
        device = Boot;
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
      };
      "/" = {
        device = Main;
        fsType = "btrfs";
        options = [
          "subvol=@root"
        ] ++ btrfsOptions;
      };
      "/home" = {
        device = Main;
        fsType = "btrfs";
        options = [
          "subvol=@home"
        ] ++ btrfsOptions;
      };
      "/nix" = {
        device = Main;
        fsType = "btrfs";
        options = [
          "subvol=@nix"
          "noatime"
        ] ++ btrfsOptions;
      };
    };
}
