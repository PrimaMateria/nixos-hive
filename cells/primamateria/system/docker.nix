{ inputs }:
let
  inherit (inputs) nixpkgs;
in
{
  config = {
    # TODO: this I want to make as option 
    nixpkgs.overlays = [
      (self: super: {
        docker = super.docker.override { iptables = pkgs.iptables-legacy; };
      })
    ];

    virtualisation.docker.enable = true;
    environment.systemPackages = with nixpkgs; [
      docker-compose
    ];
  };
}
