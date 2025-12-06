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
      caddyEnvironmentFile = {
        file = ../../../secrets/caddyEnvironmentFile.age;
        owner = "caddy";
        group = "caddy";
      };
      shackbotEnvironmentFile = {
        file = ./shackbotEnvironmentFile.age;
        owner = "shackbot";
        group = "shackbot";
      };
    };
  };
}
