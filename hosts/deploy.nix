{
  inputs,
  self,
  withSystem,
  ...
}:
{

  #

  flake = {
    deploy = {
      remoteBuild = true;
      sshUser = "root";

      nodes =
        let
          deployPath =
            nixos:
            withSystem (nixos.pkgs.system) ({ deployPkgs, ... }: deployPkgs.deploy-rs.lib.activate.nixos nixos);
        in
        {
          "oracle" = {
            # TODO: Require DNS to be set up between the machines
            hostname = "oracle";

            profiles.system = {
              user = "root";
              path = deployPath self.nixosConfigurations.oracle;
            };
          };

          "aquila" = {
            hostname = "aquila";
            sshUser = "alexw";
            remoteBuild = false; # Low memory device

            profiles.system = {
              user = "root";
              path = deployPath self.nixosConfigurations.aquila;
            };
          };

          "Frank-Laptop-NixOS" = {
            hostname = "Frank-Laptop-NixOS";
            sshUser = "alexw";
            interactiveSudo = true;

            profiles.system = {
              user = "root";
              path = deployPath self.nixosConfigurations."Frank-Laptop-NixOS";
            };
          };
        };
    };

    checks = builtins.mapAttrs (
      system: deployLib: deployLib.deployChecks self.deploy
    ) inputs.deploy-rs.lib;
  };
}
