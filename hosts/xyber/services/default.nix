{ ... }:

{
  imports = [
    ./home-assistant.nix
    ./cloudflared.nix
    ./caddy.nix
    ./samba.nix
    ./immich.nix
    ./coredns.nix
  ];

  services = {
    openssh.enable = true;
  };
}
