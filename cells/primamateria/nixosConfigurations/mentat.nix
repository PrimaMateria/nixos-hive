#
# █▄ █ █ ▀▄▀ ▄▀▄ ▄▀▀
# █ ▀█ █ █ █ ▀▄▀ ▄██ mentat
#
{
  inputs,
  cell,
}: let
  inherit (cell) bees machines installations system devices;
in {
  bee = bees.boot;

  imports = [
    machines.tower
    installations.common
    installations.standalone
    system.networkingHome
    {
      imports = [
        # system.docker
        # system.steam
        # rclone
      ];
      networking.hostName = "mentat";
    }
  ];
}
