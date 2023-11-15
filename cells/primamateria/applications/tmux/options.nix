{ inputs, cell }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  primamateria.applications.tmux = {
    sessions = lib.mkOption {
      type = lib.types.listOf (lib.types.attrs);
    };
  };
}
