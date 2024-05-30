{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;
  inherit (cell) bees cli;
in {
  bee = bees.rpi;
  imports = [
    cli.hive
    cli.shell

    {
      home = {
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "22.05";
      };
    }
  ];
}
