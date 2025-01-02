#
# █▄ █ █ ▀▄▀ ▄▀▄ ▄▀▀
# █ ▀█ █ █ █ ▀▄▀ ▄██ stalker
#
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;
  inherit (cell) bees installations system;
in {
  bee = bees.wsl;
  imports = [
    installations.common
    installations.wsl
    system.networkingHome
    {
      networking.hostName = "stalker";
      wsl.wslConf.network.hostname = "stalker";
      wsl.wslConf.network.generateHosts = false;
    }
  ];
}
