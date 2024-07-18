{ pkgs, ... }:

{
  imports = [
    ./spicetify.nix 
  ];

  home = {
    username = "alexw";
    homeDirectory = "/home/alexw";

    packages = with pkgs; [
      droidcam
      scrcpy
      fastfetch
      alsa-tools
      mangohud
      kdePackages.discover
    ];
    
    sessionVariables =  {
      MANGOHUD = "1";
    };

    stateVersion = "23.11";
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  programs = {
    firefox = {
      enable = true;
    };
    vscode = {
      enable = true;
      package = pkgs.vscode.fhsWithPackages (ps: with ps; [
        #rustup zlib openssl.dev pkg-config
      ]);
    };

    direnv.enable = true;
  };


  programs.home-manager.enable = true;
}