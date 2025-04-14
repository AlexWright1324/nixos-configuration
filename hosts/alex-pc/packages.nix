{ pkgs, chaotic, ... }:
{
  imports = [
    ../../packages/droidcam.nix
    # ./packages/cloudflareWarp.nix
  ];

  environment.systemPackages = with pkgs; [
    # CLI
    vim
    htop
    wget
    p7zip
    unrar
    lact
    podman-compose
    git-credential-oauth
  ];

  systemd.services.lact = {
    enable = true;
    description = "AMDGPU Control Daemon";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
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
    scx = {
      enable = true;
      scheduler = "scx_rusty";
    };
    ollama = {
      enable = true;
      acceleration = "rocm";
      environmentVariables = {
        HCC_AMDGPU_TARGET = "gfx1031"; # used to be necessary, but doesn't seem to anymore
      };
      rocmOverrideGfx = "10.3.1";
      #package = pkgs.ollama-rocm;
    };
    open-webui.enable = true;
  };

  programs = {
    nix-ld.enable = true;

    appimage = {
      enable = true;
      binfmt = true;
    };
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
    gamemode.enable = true;

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
      pkgs.nerd-fonts.jetbrains-mono
    ];
  };

  virtualisation = {
    waydroid.enable = true;
    libvirtd.enable = true;
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
