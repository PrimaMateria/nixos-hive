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
        settings = {
          "*" = {
            HashKnownHosts = true;
          };
          "homeServer" = {
            HostName = "homeServer";
            IdentityFile = "${secrets.identityFile.ggHomeServer}";
          };
        };
      };
    }
  ];
}
