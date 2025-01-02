#
# █▄█ ▄▀▄ █▄ ▄█ ██▀
# █ █ ▀▄▀ █ ▀ █ █▄▄ stalker
#
{
  inputs,
  cell,
}: let
  inherit (cell) bees environments secrets;
in {
  bee = bees.wsl;
  imports = [
    environments.clicraft
    {
      home = {
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "22.05";
      };

      programs.ssh = {
        enable = true;
        hashKnownHosts = true;
        matchBlocks = {
          "homeServer" = {
            host = "homeServer";
            identityFile = "${secrets.identityFile.ggHomeServer}";
          };
        };
      };
    }
  ];
}
