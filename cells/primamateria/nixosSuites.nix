{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
  inherit (cell) machines installations system;
in {
  mentat = [ 
    machines.tower
    installations.common
    installations.bare_metal
    {
      imports = [
        system.docker
        system.steam
        # rclone
      ];
      networking.hostName = "mentat";
      primamateria.system.i3.displaySetupScript =
        nixpkgs.acerMonitorDisplaySetupScript;
    }
  ];
  wokwok = [ 
    installations.common
    installations.wsl
    {
      imports = [
        system.docker
      ]; 
      networking.hostName = "wokwok";
      wsl.wslConf.network.hostname = "wokwok";
      primamateria.system.docker.wsl-fix = true;
      primamateria.system.docker.user = "primamateria";
    }
  ];
  gg = [ 
    installations.common
    installations.wsl
    {
      networking.hostName = "gg";
      wsl.wslConf.network.hostname = "gg";
    }
  ];
}
