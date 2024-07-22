{
  inputs,
  cell,
}: let
  inherit (cell) bees machines installations system devices;
in {
  bee = bees.boot;

  imports = [
    machines.beelink
    installations.common
    installations.headless
    system.networkingHome
    system.docker
    {
      networking.hostName = "homeServer";
      services.openssh.enable = true;
      networking.firewall.enable = false;
    }
  ];
}
