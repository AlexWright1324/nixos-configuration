{ inputs, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/alexw/.config/sops/age/keys.txt";
  sops.secrets.hashedPassword = {
    neededForUsers = true;
  };
}
