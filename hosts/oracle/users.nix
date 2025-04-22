{ }:
{
  users.users.alexw = {
    isNormalUser = true;
    description = "Alex Wright";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOdRGCnjfnn+e7iIPZ0VLBZkpoY1m3uh769iKLYsDi5f alexw@Alex-PC-NixOS"
    ];
  };
}
