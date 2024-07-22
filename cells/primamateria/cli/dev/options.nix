{
  inputs,
  cell,
}: let
  inherit (inputs.nixpkgs) lib;
in {
  primamateria.cli.dev = {
    projects = lib.mkOption {
      type = lib.types.listOf (lib.types.attrs);
    };
  };
}
