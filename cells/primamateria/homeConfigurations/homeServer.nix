{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;
  inherit (cell) bees cli dockerServices;
in {
  bee = bees.boot;
  imports = [
    cli.hive
    cli.shell
    cli.tmux
    cli.vcs
    dockerServices.traefik
    dockerServices.freshrss
    {
      home = {
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "22.05";
      };

      primamateria.cli.tmux = {
        sessions = [
          {
            name = "space";
            type = "prefabs";
            windows = [
              "workbench"
              "monitoring"
              "nixos-hive"
              "neovim-nix"
            ];
          }
        ];
      };
    }
  ];
}
