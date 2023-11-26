{ inputs, cell }:
let
  inherit (cell) bee installations;
in
{
  inherit bee;
  imports = [
    installations.common
    installations.wsl
    {
      networking.hostName = "wokwok";
      wsl.wslConf.network.hostname = "wokwok";
    }
  ];
}
