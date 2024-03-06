{ inputs, cell }:
let
  inherit (cell) bees environments desktop;
in
{
  bee = bees.boot;
  imports = [
    environments.clicraft
    desktop.xsession
    desktop.terminal
    desktop.office
    desktop.media
    desktop.comms
    {
      home = {
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "22.05";
      };
    }
  ];
}
