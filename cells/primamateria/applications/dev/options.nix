{ inputs, cell }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  primamateria.applications.dev = {
    projects = lib.mkOption {
      type = lib.types.listOf (lib.types.attrs);
    };
  };
}
