#
# █▄█ ▄▀▄ █▄ ▄█ ██▀
# █ █ ▀▄▀ █ ▀ █ █▄▄ workborg
{
  inputs,
  cell,
}: let
  inherit (cell) bees environments desktop;
in {
  bee = bees.boot;
  imports = [
    environments.workbench
    desktop.wayland
    desktop.office
    desktop.media
    desktop.comms
    {
      home = {
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "26.11";
      };
    }
  ];
}
