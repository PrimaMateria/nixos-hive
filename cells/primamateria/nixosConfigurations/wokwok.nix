{ inputs, cell }:
let
  inherit (cell) bees installations system;
in
{
  bee = bees.wsl;
  imports = [
    installations.common
    installations.wsl
    system.docker
    {
      networking.hostName = "wokwok";
      wsl.wslConf.network.hostname = "wokwok";

      primamateria.system.docker = {
        wsl-fix = true;
        user = "primamateria";
      };
    }
  ];
}
