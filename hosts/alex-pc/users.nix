{ config, ... }:

{
  users = {
    mutableUsers = false;

    users = {
      root = {
        hashedPasswordFile = config.age.secrets.hashedPassword.path;
      };

      alexw = {
        isNormalUser = true;
        description = "Alex Wright";
        hashedPasswordFile = config.age.secrets.hashedPassword.path;

        extraGroups = [
          "wheel"
          "libvirtd"
        ];
        subUidRanges = [
          {
            startUid = 100000;
            count = 65536;
          }
        ];
        subGidRanges = [
          {
            startGid = 100000;
            count = 65536;
          }
        ];
      };
    };
  };
}
