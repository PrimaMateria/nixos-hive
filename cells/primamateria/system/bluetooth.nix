{
  inputs,
  cell,
}: {
  config = {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
