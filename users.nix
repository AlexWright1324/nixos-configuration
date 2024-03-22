{ config, lib, pkgs, ... }:

{
  users.users.alexw = {
    isNormalUser = true;
    description = "Alex Wright";
    extraGroups = [ "wheel" ];
  };
}