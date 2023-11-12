{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
  inherit (cell) system;
in
{
  imports = [
    system.wsl
    system.essentials
    system.age
  ];
}
