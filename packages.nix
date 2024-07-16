{ config, pkgs, ... }:
{
  imports = [
    ./packages/droidcam.nix
    # ./packages/cloudflareWarp.nix
  ];

  environment.systemPackages = with pkgs; [
    # CLI
    scx # Kernel Scheduler
    git
    vim
    htop
    wget
    p7zip
    unrar
    docker-compose
    git-credential-oauth
  ];

  # Services
  services.tailscale.enable = true;
  services.fwupd.enable = true;
  services.flatpak.enable = true;
  services.printing.enable = true;

  services.udev.packages = [
    pkgs.android-udev-rules
  ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
  
  # Programs Configuration
  programs.adb.enable = true;
  programs.virt-manager.enable = true;
  programs.partition-manager.enable = true;

  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraPkgs = pkgs: [ pkgs.gperftools ];
    };
    gamescopeSession.enable = true;
  };

  programs.git = {
    enable = true;
    config = {
      credential.helper = "${pkgs.git-credential-oauth}/bin/git-credential-oauth";
    };
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };

  virtualisation = {
    libvirtd.enable = true;
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
