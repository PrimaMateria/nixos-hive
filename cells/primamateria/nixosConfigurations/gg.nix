{ inputs, cell }:
let
  inherit (inputs.nixpkgs) lib;
  inherit (cell) bees installations;
in
{
  bee = lib.traceVal bees.wsl;
  imports = [
    installations.common
    installations.wsl
    {
      networking.hostName = "gg";
      wsl.wslConf.network.hostname = "gg";
    }
  ];
}
