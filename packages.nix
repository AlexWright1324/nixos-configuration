{ config, lib, pkgs, inputs, ... }:
{
  imports = [ inputs.spicetify-nix.nixosModule ];

  # Packages
  environment.systemPackages = with pkgs; [
    # CLI apps
    scx # Kernel Scheduler
    git
    vim
    htop
    wget
    p7zip
    unrar
    scrcpy
    neofetch
    cloudflare-warp
    git-credential-oauth

    # GUI Apps
    discord
    firefox
    stremio
    mangohud
    vscode.fhs
    dolphin-emu
    protonup-qt
    qbittorrent
    qt6.qtimageformats # WebP Support
  ];

  environment.sessionVariables =  {
    MANGOHUD = "1";
  };

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
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
  
  # Programs Configuration
  programs.adb.enable = true;
  programs.direnv.enable = true;
  programs.kdeconnect.enable = true;
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

  # configure spicetify :)
  programs.spicetify = let 
    spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
  in {
    enable = true;
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle # shuffle+ (special characters are sanitized out of ext names)
      hidePodcasts
      adblock
    ];
  };

  # Extra Fonts
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };
}
