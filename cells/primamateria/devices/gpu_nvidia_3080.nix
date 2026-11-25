{
  inputs,
  cell,
}: {
  config = {
    # Despite the name this only selects the NVIDIA kernel driver; it does not
    # start an X server. Wayland compositors need kernel modesetting on top.
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia.modesetting.enable = true;

    # Newer nixpkgs asserts on `hardware.nvidia.open` being a real boolean;
    # it now defaults to null to force an explicit choice. false keeps the
    # proprietary kernel module this card has always run with.
    hardware.nvidia.open = false;
  };
}
