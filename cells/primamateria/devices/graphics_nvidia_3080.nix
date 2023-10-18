{}:
{
  config = {
    services.xserver.videoDrivers = [ "nvidia" ];
    services.xserver.screenSection = ''
      Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      Option         "AllowIndirectGLXProtocol" "off"
      Option         "TripleBuffer" "on"
    '';
  };
}
