{ inputs, cell }:
let
  inherit (cell) applications;
in
{
  mentat = [
    applications.shell
  ];
  wokwok = [
    applications.shell
  ];
  gg = [
    applications.shell
  ];
}
