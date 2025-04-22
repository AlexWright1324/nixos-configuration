{
  lib,
  ...
}:

{
  imports = [
    ./filesystem.nix
    ./hardware.nix
    ./desktop.nix
    ./users.nix
    ./packages.nix
    ./home
    ../../modules/locale.nix
    ../../modules/scripts.nix
    ../../modules/fastBoot.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "x86_64-linux";
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  zramSwap.enable = true;

  # Limits.conf
  security.pam.loginLimits = [
    {
      domain = "*";
      item = "nofile";
      type = "hard";
      value = "65535";
    }
    {
      domain = "*";
      item = "nofile";
      type = "soft";
      value = "8192";
    }
  ];

  # DO NOT EDIT
  system.stateVersion = "23.11";
}
