{ config, lib, pkgs, ... }:
{
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  
  # Packages
  environment.systemPackages = with pkgs; [
    
    # CLI apps
    git
    vim
    htop
    wget
    scrcpy
    neofetch
    cloudflare-warp
    git-credential-oauth

    # GUI Apps
    firefox
    stremio
    vscode.fhs
    protonup-qt
    qt6.qtimageformats # WebP Support
    nur.repos.nltch.spotify-adblock
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
