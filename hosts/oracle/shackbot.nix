{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.shackbot.nixosModules.default
  ];
  services.shackbot = {
    enable = true;
    environmentFile = config.age.secrets.shackbotEnvironmentFile.path;
  };
}
