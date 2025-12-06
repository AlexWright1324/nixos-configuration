{ ... }:

{
  imports = [
    ./home-assistant.nix
    ./cloudflared.nix
    ./vaultwarden.nix
    ./sunshine.nix
    ./coredns.nix
    ./kanidm.nix
    ./immich.nix
    ./caddy.nix
    ./samba.nix
  ];

  services = {
    openssh.enable = true;
  };
}
