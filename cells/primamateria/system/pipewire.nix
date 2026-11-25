# Audio via PipeWire (with PulseAudio and ALSA compatibility). Replaces the old
# PulseAudio setup in system/sound.nix for Wayland machines.
{
  inputs,
  cell,
}: {
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
}
