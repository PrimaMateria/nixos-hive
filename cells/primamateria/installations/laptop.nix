# A physical laptop with a Wayland desktop.
{
  inputs,
  cell,
}: let
  inherit (cell) system installations;
in {
  imports = [
    installations.graphical
    system.laptop
  ];
}
