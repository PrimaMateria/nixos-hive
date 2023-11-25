{ inputs, cell, config, ... }:
let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;

  cfg = config.primamateria.applications.dev;
  utils = import ./__utils.nix { inherit lib nixpkgs cfg; };

in {
  config = {
    systemd.user.services = {
      devProjectInitializer = {
        Unit = {
          Description = "Check and clone Git repository if directory doesn't exist";
          After = "network.target";
        };

        Service = {
          Type = "simple";
          ExecStart = "${utils.devProjectInitializer}/bin/devProjectInitializer"; 
        };

        Install = {
          WantedBy = ["default.target"];
        };
      };
    };
  };
}
