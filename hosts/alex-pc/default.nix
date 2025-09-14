{
  inputs,
  lib,
  ...
}:

{
  imports = [
    ./filesystem.nix
    ./hardware.nix
    ./packages.nix
    ./desktop.nix
    ./users.nix
    ./secrets
    ./home

    ../../modules/locale.nix
    ../../modules/scripts.nix
    ../../modules/fastBoot.nix
    inputs.nixos-hardware.nixosModules.gigabyte-b550

    inputs.chaotic.nixosModules.default
    inputs.nix-index-database.nixosModules.nix-index
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
      trusted-users = [
        "@wheel"
      ];
      extra-substituters = [
        "https://cache.nixos.org"
        "https://cache.garnix.io"
      ];
      extra-trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
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

  # Not needed in 25.11 hopefully
  system.rebuild.enableNg = true;

  # DO NOT EDIT
  system.stateVersion = "23.11";
}
