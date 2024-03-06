{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
in
{
  home.packages = with nixpkgs; [
    element-desktop
    slack
    skypeforlinux
    discord
  ];
}
