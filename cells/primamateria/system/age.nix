{ inputs, cell }:
let 
  inherit (inputs) nixpkgs agenix;
in
{
  imports = [
    agenix.nixosModules.default
  ];

  environment.systemPackages = [ agenix.packages.${nixpkgs.system}.default ];
  age = {
    identityPaths = [ "/home/primamateria/.ssh/hive" ];
    secrets.common.file = ../common.age;
  };
}
