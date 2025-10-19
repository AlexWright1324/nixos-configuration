{ ... }:

{
  imports = [
    ./home-assistant.nix
    ./caddy.nix
    ./cloudflared.nix
  ];

  services = {
    openssh.enable = true;
  };
}
