{ config, lib, pkgs, ... }:
{
  # Packages
  environment.systemPackages = with pkgs; [
    # CLI apps
    scx # Kernel Scheduler
    git
    vim
    htop
    wget
    p7zip
    scrcpy
    neofetch
    cloudflare-warp
    git-credential-oauth

    # GUI Apps
    firefox
    stremio
    vscode.fhs
    dolphin-emu
    protonup-qt
    qbittorrent
    qt6.qtimageformats # WebP Support
    config.nur.repos.nltch.spotify-adblock
    discord
    (steam.override { extraLibraries = pkgs: [ pkgs.gperftools ]; })
  ];

  systemd.packages = with pkgs; [
    cloudflare-warp
  ];

  #systemd.targets.multi-user.wants = [
  #  "warp-svc.service"
  #];

  # Services
  services.fwupd.enable = true;
  services.flatpak.enable = true;
  services.printing.enable = true;
  services.udev.packages = [
    pkgs.android-udev-rules
    pkgs.dolphinEmu
  ];
  
  # Programs Configuration
  programs.adb.enable = true;
  programs.kdeconnect.enable = true;
  programs.partition-manager.enable = true;
  
  programs.git = {
    enable = true;
    config = {
      credential.helper = "${pkgs.git-credential-oauth}/bin/git-credential-oauth";
    };
  };

  # Extra Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}
