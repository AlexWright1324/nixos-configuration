{ config, lib, pkgs, ... }:
{
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  services.flatpak.enable = true;
  
  environment.systemPackages = with pkgs; [
    
    # CLI apps
    git
    vim
    htop
    wget
    neofetch
    cloudflare-warp
    git-credential-oauth

    # Apps

    firefox
    stremio
    vscode.fhs
    protonup-qt
    qt6.qtimageformats # WebP Support
    nur.repos.nltch.spotify-adblock
    (discord.override { withOpenASAR = true; })
    (steam.override { extraLibraries = pkgs: [ pkgs.gperftools ]; })
  ];
  
  systemd.packages = with pkgs; [
    cloudflare-warp
  ];

  #systemd.targets.multi-user.wants = [
  #  "warp-svc.service"
  #];

  programs.git = {
    enable = true;
    config = {
      credential.helper = "${pkgs.git-credential-oauth}/bin/git-credential-oauth";
    };
  };

  programs.partition-manager.enable = true;
  programs.kdeconnect.enable = true;

  # Extra Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}
