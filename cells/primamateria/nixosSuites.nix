{ inputs, cell }:
let
  inherit (cell) machines installations;
in {
  mentat = [ 
    machines.tower
    installations.common
    installations.bare_metal
  ];
  wokwok = [ 
    installations.common
    installations.wsl
  ];
  gg = [ 
    installations.common
    installations.wsl
  ];
}
