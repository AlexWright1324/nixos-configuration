{ ... }:

{
  imports = [
    ./spicetify.nix
  ];

  home = {
    username = "alexw";
    homeDirectory = "/home/alexw";

    #packages = with pkgs; [];

    sessionVariables = {
      MANGOHUD = "1";
    };

    stateVersion = "23.11";
  };

  programs = {
    # Development
    bash.enable = true;
    vscode.enable = true;
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    home-manager.enable = true;
  };
}
