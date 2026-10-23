{
  inputs,
  cell,
}: {
  config = {
    services.xserver.videoDrivers = ["nvidia"];

    # Newer nixpkgs asserts on `hardware.nvidia.open` being a real boolean;
    # it now defaults to null to force an explicit choice. false keeps the
    # proprietary kernel module this card has always run with.
    hardware.nvidia.open = false;
    services.xserver.screenSection = ''
      Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      Option         "AllowIndirectGLXProtocol" "off"
      Option         "TripleBuffer" "on"
    '';
  };
}
