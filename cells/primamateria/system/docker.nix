{ inputs, cell, config }:
let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;
  cfg = config.primamateria.system.docker;
in
with lib; {
  options.primamateria.system.docker = {
    wsl-fix = mkOption {
      type = lib.types.bool;
      default = false;
    };
    user = mkOption {
      type = lib.types.str;
      default = "primamateria";
    };
  };

  config = {
    # TODO: verity that it will merge and not override
    users.users.${cfg.user} = {
      extraGroups = [ "docker" ];
    };

    virtualisation.docker = {
      enable = true;
      package = mkIf cfg.wsl-fix (
        nixpkgs.docker.override {
          iptables = nixpkgs.iptables-legacy;
        }
      );
    };

    environment.systemPackages = with nixpkgs; [
      docker-compose
    ];
  };
}
