{ config, pkgs, ... }:

{
  users = {
    mutableUsers = false;

    users = {
      root = {
        hashedPasswordFile = config.age.secrets.hashedPassword.path;
      };

      alexw = {
        isNormalUser = true;
        description = "Alex Wright";
        extraGroups = [
          "wheel"
          "libvirtd"
        ];
        hashedPasswordFile = config.age.secrets.hashedPassword.path;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    # CLI
    vim
    htop
    wget
    p7zip
    unrar
    tmux
  ];
}
