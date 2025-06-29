{
  inputs,
  self,
  ...
}:
{

  #

  flake = {
    deploy = {
      remoteBuild = true;
      sshUser = "root";

      nodes = {
        "oracle" = {
          # TODO: Require DNS to be set up between the machines
          hostname = "oracle";

          profiles.system = {
            user = "root";
            path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.oracle;
          };
        };
        "Frank-Laptop-NixOS" = {
          hostname = "Frank-Laptop-NixOS";
          sshUser = "alexw";
          interactiveSudo = true;

          profiles.system = {
            user = "root";
            path =
              inputs.deploy-rs.lib.x86_64-linux.activate.nixos
                self.nixosConfigurations."Frank-Laptop-NixOS";
          };
        };
      };
    };

    checks = builtins.mapAttrs (
      system: deployLib: deployLib.deployChecks self.deploy
    ) inputs.deploy-rs.lib;
  };
}
