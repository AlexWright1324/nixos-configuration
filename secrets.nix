let
  users = {
    alexw = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOdRGCnjfnn+e7iIPZ0VLBZkpoY1m3uh769iKLYsDi5f";
  };
  allUsers = builtins.attrValues users;

  systems = {
    "Alex-PC-NixOS" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPwCLIiihT2QxI6RPeBSOp5iZ21oXCkFK8JOLb+7JkHI";
    oracle = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID0lw1aR48cuhhj7GJBTYkoOu/j6zIR03KYMv3dAxM4b";
  };
  allSystems = builtins.attrValues systems;

  allSystemsAndUsers = allSystems ++ allUsers;
in
{
  "secrets/hashedPassword.age".publicKeys = allSystemsAndUsers;
}
