{ pkgs, ... }:
{
  imports = [
    ../../packages/droidcam.nix
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

    # Libraries
    qt6.qtimageformats
  ];

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
        HCC_AMDGPU_TARGET = "gfx1031";
      };
      rocmOverrideGfx = "10.3.1";
      package = pkgs.ollama-rocm;
    };
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
