{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
  inherit (cell) system;
in
{
  import = [
    system.wsl
    system.essentials
    system.vnc
  ];
}
