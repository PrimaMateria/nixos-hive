{ inputs, cell }:
let
  inherit (cell._lib) homeProfiles;
in
rec {

  chill = with homeProfiles; [
    shell
  ];

  home = with homeProfiles; [
    shell
  ];

  work = with homeProfiles; [
    shell
  ];
}
