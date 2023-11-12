{ inputs, cell }:
let
  inherit (cell) bee installations;
  inherit (inputs) agenix;
in
{
  inherit bee;
  imports = [
    agenix.nixosModules.default
    installations.common
    installations.wsl
    {
      networking.hostName = "gg";
      wsl.wslConf.network.hostname = "gg";
    }
  ];
}
