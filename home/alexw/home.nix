{inputs, ...}: {
  home = {
    username = "alexw";
    homeDirectory = "/home/alexw";
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
  };

  imports = [
    ./spicetify.nix
  ];
}