{
  inputs,
  self,
  ...
}:
{
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
      };
    };

    checks = builtins.mapAttrs (
      system: deployLib: deployLib.deployChecks self.deploy
    ) inputs.deploy-rs.lib;
  };
}
