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
    desktop.common
    desktop.work
    {
      home = {
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "26.11";
      };
    }
  ];
}
