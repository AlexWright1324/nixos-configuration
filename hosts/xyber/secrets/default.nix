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

      tshotc = {
        file = ../../../secrets/wifi/tshotc.age;
      };

      cloudflared = {
        file = ../../../secrets/cloudflared.age;
      };
      cloudflared-home-assistant = {
        file = ./cloudflared/home-assistant.age;
      };
    };
  };
}
