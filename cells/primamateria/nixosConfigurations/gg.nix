{ inputs, cell }:
let
  inherit (cell) bee machines installations system;
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
