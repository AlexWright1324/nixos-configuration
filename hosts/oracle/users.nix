{ config, ... }:

{
  users = {
    mutableUsers = false;

    users = {
      root = {
        hashedPasswordFile = config.age.secrets.hashedPassword.path;

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOdRGCnjfnn+e7iIPZ0VLBZkpoY1m3uh769iKLYsDi5f"
        ];
      };

      alexw = {
        isNormalUser = true;
        description = "Alex Wright";

        hashedPasswordFile = config.age.secrets.hashedPassword.path;

        extraGroups = [
          "wheel"
          "minecraft"
        ];

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOdRGCnjfnn+e7iIPZ0VLBZkpoY1m3uh769iKLYsDi5f"
        ];
      };
    };
  };
}
