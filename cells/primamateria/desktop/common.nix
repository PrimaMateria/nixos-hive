# Desktop apps for every graphical host.
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  home.packages = with nixpkgs; [
    element-desktop
    enpass
    firefox
    mpv
  ];
}
