{ inputs, super }:
let
  inherit (inputs) nixpkgs;

  i3block = super.lib.buildContribBlock {
    name = "kbdd_layout";
    deps = [ nixpkgs.kbdd ];
  };
in
"${i3block}/kbdd_layout"
