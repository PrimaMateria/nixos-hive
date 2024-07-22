{
  inputs,
  cell,
}: let
  inherit (cell) system installations;
in {
  imports = [
    installations.headless
    {boot.loader.timeout = 10000;}
    system.bluetooth
    system.sound
    system.xserver
  ];
}
