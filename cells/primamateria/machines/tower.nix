{ inputs, cell }:
let
  inherit (cell) devices;
in
{
  imports = [
    devices.disk_ssd_win
    devices.ethernet
    devices.graphics_nvidia_3060
    devices.mouse_logitech_g502
    devices.printer_hp_deskjet_3630
  ];
}
