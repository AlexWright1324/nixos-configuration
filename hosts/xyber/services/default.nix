{ ... }:

{
  imports = [
    ./home-assistant.nix
    ./cloudflared.nix
    ./vaultwarden.nix
    ./smokeping.nix
    ./sunshine.nix
    ./coredns.nix
    ./rtl-sdr.nix
    ./kanidm.nix
    ./immich.nix
    ./ollama.nix
    ./caddy.nix
    ./samba.nix
  ];

  services = {
    openssh.enable = true;
  };
}
