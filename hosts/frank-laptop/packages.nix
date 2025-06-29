{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # CLI
    htop
    wget
    p7zip
    unrar

    # Desktop
    kdePackages.discover
    kdePackages.krfb

    # Libraries
    qt6.qtimageformats
  ];

  services = {
    openssh.enable = true;
    fwupd.enable = true;
    flatpak.enable = true;
    printing.enable = true;
    udev.packages = [
      pkgs.android-udev-rules
    ];
    udisks2.enable = true;
  };

  programs = {
    adb.enable = true;

    partition-manager.enable = true;

    firefox.enable = true;

    appimage = {
      enable = true;
      binfmt = true;
    };

    kdeconnect.enable = true;
    k3b.enable = true;

    git.enable = true;
  };
}
