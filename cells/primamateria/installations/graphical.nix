# A machine with a screen: audio, bluetooth and the niri + Noctalia desktop.
{
  inputs,
  cell,
}: let
  inherit (cell) system installations;
in {
  imports = [
    installations.headless
    system.bluetooth
    system.pipewire
    system.wayland
  ];
}
