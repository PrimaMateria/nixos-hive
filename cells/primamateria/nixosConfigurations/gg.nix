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
      networking.hostName = "gg";
      wsl.wslConf.network.hostname = "gg";
    }
  ];
}
