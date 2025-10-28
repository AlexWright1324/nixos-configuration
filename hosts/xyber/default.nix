{
  ...
}:
{
  imports = [
    ./virtualization.nix
    ./networking.nix
    ./hardware.nix
    ./disko.nix
    ./users.nix
    ./services
    ./secrets
  ];

  nixpkgs = {
    config.allowUnfree = true;
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [ "alexw" ];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 10d";
    };
  };

  zramSwap.enable = true;

  systemd.enableEmergencyMode = false;

  # DO NOT EDIT
  system.stateVersion = "25.05";
}
