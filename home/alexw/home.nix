{ inputs, ... }: {
  home = {
    username = "alexw";
    homeDirectory = "/home/alexw";
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
  };

  imports = [
    inputs.spicetify-nix.nixosModule
    ./spicetify.nix
  ];
}