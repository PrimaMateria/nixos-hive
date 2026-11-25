# A physical laptop with a Wayland desktop.
{
  inputs,
  cell,
}: let
  inherit (cell) system installations;
in {
  imports = [
    installations.headless
    system.laptop
    system.bluetooth
    system.pipewire
    system.wayland
  ];
}
