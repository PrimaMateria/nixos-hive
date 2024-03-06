{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
in
{
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  environment.systemPackages = with nixpkgs; [ pavucontrol ];
}
