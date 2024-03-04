{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;
  inherit (cell) bee bees installations;
in
{
  bee = bees.wsl;
  imports = [
    installations.common
    installations.wsl
    {
      networking.hostName = "gg";
      wsl.wslConf.network.hostname = "gg";
    }
  ];
}
