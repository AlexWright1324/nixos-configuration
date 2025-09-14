{ inputs, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  age = {
    identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      hashedPassword = {
        file = ../../../secrets/passwords/hashedPassword.age;
      };
      forwardingSecret = {
        file = ./forwardingSecret.age;
        owner = "minecraft";
        group = "minecraft";
      };
      caddyEnvironmentFile = {
        file = ./caddyEnvironmentFile.age;
        owner = "caddy";
        group = "caddy";
      };
    };
  };
}
