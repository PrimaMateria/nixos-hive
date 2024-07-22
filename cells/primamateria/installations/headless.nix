{
  inputs,
  cell,
}: let
  inherit (cell) system;
in {
  imports = [
    system.bootloader
    system.essentials
  ];
}
