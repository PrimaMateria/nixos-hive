#
# █▄█ ▄▀▄ █▄ ▄█ ██▀
# █ █ ▀▄▀ █ ▀ █ █▄▄ wokwok
{
  inputs,
  cell,
}: let
  inherit (cell) bees environments;
in {
  bee = bees.wsl;
  imports = [
    environments.workbench

    {
      home = {
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "22.05";
      };
    }
  ];
}
