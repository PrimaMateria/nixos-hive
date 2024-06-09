{
  inputs,
  cell,
}: let
  inherit (cell) bees environments raspberrypi;
in {
  bee = bees.wsl;
  imports = [
    environments.clicraft
    raspberrypi.client

    {
      home = {
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "22.05";
      };
    }
  ];
}
