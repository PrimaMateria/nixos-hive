# Laptop basics: firmware, firmware updates, wifi via NetworkManager.
{
  inputs,
  cell,
}: {
  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;
  networking.networkmanager.enable = true;
}
