# Personal-machine extras, kept off the work laptop.
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  home.packages = with nixpkgs; [
    calibre
    discord
  ];
}
