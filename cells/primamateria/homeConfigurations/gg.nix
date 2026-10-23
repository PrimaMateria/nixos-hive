#
# █▄█ ▄▀▄ █▄ ▄█ ██▀
# █ █ ▀▄▀ █ ▀ █ █▄▄ gg
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
          # ssh_config Host patterns are case-sensitive, so a bare
          # `ssh homeserver` skips this block and falls back to ~/.ssh/id_rsa.
          # Both spellings are listed so either one picks up the right key.
          "homeServer homeserver" = {
            HostName = "homeServer";
            IdentityFile = "${secrets.identityFile.ggHomeServer}";
          };
        };
      };
    }
  ];
}
