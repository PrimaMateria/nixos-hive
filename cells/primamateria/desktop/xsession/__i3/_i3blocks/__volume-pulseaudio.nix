{
  inputs,
  super,
}: let
  inherit (inputs) nixpkgs;

  i3block = super.lib.buildContribBlock {
    name = "volume-pulseaudio";
    deps = [
      nixpkgs.alsaUtils
      nixpkgs.pulseaudio
      nixpkgs.envsubst
    ];
  };
in "${i3block}/volume-pulseaudio"
