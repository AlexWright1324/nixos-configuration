{ pkgs, ... }:
{
  imports = [
    ../../packages/lact.nix
  ];

  environment.systemPackages = with pkgs; [
    # CLI
    vim
    htop
    wget
    p7zip
    unrar
    podman-compose
    git-credential-oauth
    fastfetch

    # Android
    scrcpy

    # Gaming
    lutris
    heroic
    mangohud

    # Desktop
    kdePackages.discover
    kdePackages.krfb

    # Libraries
    qt6.qtimageformats
  ];

  services = {
    openssh.enable = true;
    tailscale.enable = true;
    fwupd.enable = true;
    flatpak.enable = true;
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
    scx = {
      enable = true;
      scheduler = "scx_rusty";
    };
    ollama = {
      enable = true;
      acceleration = "rocm";
      environmentVariables = {
        HCC_AMDGPU_TARGET = "gfx1031";
      };
      rocmOverrideGfx = "10.3.1";
      package = pkgs.ollama-rocm;
    };
  };

  programs = {
    # Binaries
    nix-ld.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };

    # Android
    adb.enable = true;
    #droidcam.enable = true;

    virt-manager.enable = true;
    partition-manager.enable = true;

    # Desktop
    kde-pim = {
      enable = true;
      kontact = true;
      kmail = true;
    };
    kdeconnect = {
      enable = true;
    };

    # Gaming
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    gamemode.enable = true;

    git = {
      enable = true;
      config = {
        credential.helper = "${pkgs.git-credential-oauth}/bin/git-credential-oauth";
      };
    };
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
