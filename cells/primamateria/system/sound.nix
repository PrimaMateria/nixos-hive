{ inputs, cell }:
{
  config = {
    sound.enable = true;
    hardware.pulseaudio.enable = true;
  };
}
