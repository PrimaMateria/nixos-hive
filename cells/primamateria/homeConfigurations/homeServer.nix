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
    cli.shellMin
    dockerServices.traefik
    dockerServices.freshrss
    {
      home = {
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "22.05";
      };
    }
  ];
}
