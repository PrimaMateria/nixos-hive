#
# █▄ █ █ ▀▄▀ ▄▀▄ ▄▀▀
# █ ▀█ █ █ █ ▀▄▀ ▄██ mentat
#
# Home desktop tower, native NixOS with niri + Noctalia.
{
  inputs,
  cell,
}: let
  inherit (cell) bees machines installations system;
in {
  bee = bees.boot;
  imports = [
    machines.tower
    installations.common
    installations.graphical
    system.networkingHome
    {
      boot.loader.timeout = 10000;
      networking.hostName = "mentat";
    }
  ];
}
