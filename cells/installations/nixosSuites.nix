{ inputs, cell }:
let
  inherit (cell) nixosProfiles;
in
with nixosProfiles; rec {
  baremetal = [ core ];
  wsl = [ core  wsl ];
}
