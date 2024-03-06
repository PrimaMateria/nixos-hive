{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
in
{
  home.packages = with nixpkgs; [
    spotify
    mpv
    calibre
  ];

  programs.kodi = {
    enable = true;
  };
}
