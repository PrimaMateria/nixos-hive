{ inputs }:
let
  inherit (inputs) nixpkgs dmenu-primamateria;
in
dmenu-primamateria.packages.${nixpkgs.system}.dmenu-primamateria

