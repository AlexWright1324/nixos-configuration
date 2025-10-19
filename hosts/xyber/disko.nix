{
  inputs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
  ];

  disko.devices.disk = {
    mmc = {
      # type = "disk";
      device = "/dev/disk/by-id/mmc-SCA64G_0xaf1eb605";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 1;
            name = "ESP";
            type = "EF00";
            size = "512M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          NixOS = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "@nixos-root" = {
                  mountpoint = "/";
                  mountOptions = [ "compress=zstd" ];
                };
                "@nixos-home" = {
                  mountpoint = "/home";
                  mountOptions = [ "compress=zstd" ];
                };
                "@nixos-nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
