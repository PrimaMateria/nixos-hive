{ inputs, config }:
let
  inherit (inputs) nixpkgs;
  cfg = config.primamateria.system.docker;
in
{
  options.primamateria.system.docker = {
    wsl-fix = nixpkgs.lib.mkOption {
      type = Boolean;
      default = false;
    };
    user = nixpkgs.lib.mkOption {
      type = String;
      default = "nixos";
    };
  };
  config = {

    nixpkgs.overlays =
      mkIf cfg.wsl-fix [
        (self: super: {
          docker = super.docker.override { iptables = pkgs.iptables-legacy; };
        })
      ];

    # TODO: verity that it will merge and not override
    users.users.${cfg.user} = {
      extraGroups = [ "docker" ];
    };

    virtualisation.docker.enable = true;
    environment.systemPackages = with nixpkgs; [
      docker-compose
    ];
  };
}
