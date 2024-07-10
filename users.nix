{ config, lib, pkgs, ... }:

{
  users.users.alexw = {
    isNormalUser = true;
    description = "Alex Wright";
    extraGroups = [ "wheel" "libvirtd" ];
    subUidRanges = [{ startUid = 100000; count = 65536; }];
    subGidRanges = [{ startGid = 100000; count = 65536; }];
  };
}
