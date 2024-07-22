{
  inputs,
  cell,
}: let
  inherit (cell) devices;
in {
  imports = [
    devices.cpu_intel
    devices.disk_beelink_nix
    devices.ethernet_beelink
  ];
}
