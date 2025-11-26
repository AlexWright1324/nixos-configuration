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
        hashedPasswordFile = config.age.secrets.hashedPassword.path;

        extraGroups = [
          "wheel"
          "libvirtd"
          "uinput"
          "ydotool"
        ];

        linger = true;
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
