{ inputs, cell }:
let
  inherit (cell) bee installations system;
in
{
  inherit bee;
  imports = [
    installations.common
    installations.wsl
    {
      imports = [
        # system.docker
      ];
      networking.hostName = "wokwok";
      wsl.wslConf.network.hostname = "wokwok";
      primamateria.system.docker.wsl-fix = true;
      primamateria.system.docker.user = "primamateria";
    }
  ];
}
