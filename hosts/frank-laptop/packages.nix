{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # CLI
    git
    htop
    wget
    p7zip
    unrar
  ];

  services = {
    openssh.enable = true;
    fwupd.enable = true;
    flatpak.enable = true;
    printing.enable = true;
    udev.packages = [
      pkgs.android-udev-rules
    ];
  };

  programs = {
    adb.enable = true;
    partition-manager.enable = true;
    firefox.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };
}
