{
  inputs,
  cell,
}: let
  inherit (cell) devices;
in {
  imports = [
    devices.cpu_intel
    devices.gpu_nvidia_3080
    devices.disk_ssd_nix
    devices.disk_ssd_win
    devices.ethernet_tower
    devices.mouse_logitech_g502
    devices.printer_hp_deskjet_3630
    devices.monitor_acer
  ];
}
