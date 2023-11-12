{ inputs, cell }:
let
  inherit (inputs) age;
in
{
  age.secrets.common.file = ./common.secret.nix;
  common = import age.secrets.common.path;
}
