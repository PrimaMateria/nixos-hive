{ inputs, cell }:
let
  inherit (cell) machines installations modules;
in {
  mentat = [ 
    machines.tower
    installations.common
    installations.bare_metal
    {
      imports = [
        modules.docker
        modules.steam
        # rclone
      ];
    }
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
