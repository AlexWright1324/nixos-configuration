{
  inputs,
  self,
  ...
}:
{
  imports = [
    ./nova-sdr
    #./system-bridge
    ./home-assistant
  ];

  perSystem =
    {
      system,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          self.overlays.home-assistant
        ];
      };
    };
}
