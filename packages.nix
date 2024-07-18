{ config, pkgs, ... }:
{
  imports = [
    ./packages/droidcam.nix
    # ./packages/cloudflareWarp.nix
  ];

  environment.systemPackages = with pkgs; [
    # CLI
    scx # Kernel Scheduler
    vim
    htop
    wget
    p7zip
    unrar
    lact
    docker-compose
    git-credential-oauth
  ];

  systemd.services.lact = {
    enable = true;
    description = "AMDGPU Control Daemon";
    after = ["multi-user.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
  };

  services = {
    tailscale.enable = true;
    fwupd.enable = true;
    flatpak.enable = true;
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
    udev.packages = [
      pkgs.android-udev-rules
    ];
  };
  
  programs = {
    adb.enable = true;
    virt-manager.enable = true;
    partition-manager.enable = true;

    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs: [ pkgs.gperftools ];
      };
      gamescopeSession.enable = true;
    };

    git = {
      enable = true;
      config = {
        credential.helper = "${pkgs.git-credential-oauth}/bin/git-credential-oauth";
      };
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
