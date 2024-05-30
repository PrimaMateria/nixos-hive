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
    installations.bare_metal
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
