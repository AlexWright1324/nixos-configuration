{ config, lib, pkgs, ... }:
{
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  environment.systemPackages = with pkgs; [
    htop
    neofetch
    vim
    wget
    firefox
    cloudflare-warp
    (discord.override {
      withOpenASAR = true;
    })
    vscode.fhs
    protonup-qt
    nur.repos.nltch.spotify-adblock    #for installing spotify-adblock
    (steam.override { extraLibraries = pkgs: [ pkgs.gperftools ]; })
    stremio
    qt6.qtimageformats
    git
    git-credential-oauth
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
}
