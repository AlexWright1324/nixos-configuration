let
  users = {
    alexw = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOdRGCnjfnn+e7iIPZ0VLBZkpoY1m3uh769iKLYsDi5f";
  };
  allUsers = builtins.attrValues users;

  systems = {
    "Alex-PC-NixOS" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPwCLIiihT2QxI6RPeBSOp5iZ21oXCkFK8JOLb+7JkHI";
    oracle = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID0lw1aR48cuhhj7GJBTYkoOu/j6zIR03KYMv3dAxM4b";
    xyber = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIk0NQz5atzhlYuHHCzaUvkXOQGm5yX+LeRhQEceFw6P";
  };
  allSystems = builtins.attrValues systems;

  allSystemsAndUsers = allSystems ++ allUsers;
in
{
  "secrets/passwords/hashedPassword.age".publicKeys = allSystemsAndUsers;
  "secrets/wifi/tshotc.age".publicKeys = allSystemsAndUsers;
  "secrets/cloudflared.age".publicKeys = allSystemsAndUsers;
  "secrets/caddyEnvironmentFile.age".publicKeys = allSystemsAndUsers;

  "hosts/oracle/secrets/forwardingSecret.age".publicKeys = allSystemsAndUsers;

  "hosts/xyber/secrets/cloudflared/home-assistant.age".publicKeys = [
    users.alexw
    systems.xyber
  ];

}
