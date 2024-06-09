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
    cli.pureNix
    cli.hive
    cli.shellMin

    {
      home = {
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "22.05";
      };

      # nix.settings = {
      #   extra-experimental-features = ["nix-command" "flakes"];
      # };
    }
  ];
}
