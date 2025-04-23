{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # CLI
    vim
    htop
    wget
    p7zip
    unrar
  ];

  programs = {
    nix-ld.enable = true;

    appimage = {
      enable = true;
      binfmt = true;
    };

    git.enable = true;
  };

  services = {
    openssh = {
      enable = true;
    };
  };
}
