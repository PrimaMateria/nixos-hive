#
# █▄█ ▄▀▄ █▄ ▄█ ██▀
# █ █ ▀▄▀ █ ▀ █ █▄▄ mentat
#
# Home desktop: personal CLI, the niri + Noctalia desktop and leisure apps.
# No work tools (those live in environments.workbench).
{
  inputs,
  cell,
}: let
  inherit (cell) bees environments desktop;
in {
  bee = bees.boot;
  imports = [
    environments.clicraft
    desktop.wayland
    desktop.office
    desktop.media
    desktop.comms
    desktop.leisure
    {
      home = {
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "22.05";
      };
    }
  ];
}
