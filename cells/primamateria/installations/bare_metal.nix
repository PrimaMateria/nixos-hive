{ inputs, cell }:
let
  inherit (cell) system;
in
{
  imports = [
    system.bootloader
    system.bluetooth
    system.networking
    system.sound
    system.essentials
    system.manager
  ];
}
