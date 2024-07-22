{
  inputs,
  super,
}: let
  inherit (inputs) nixpkgs;

  scratchpad = nixpkgs.writeShellApplication {
    name = "dmenu-scratchpad";
    runtimeInputs = [nixpkgs.jq];
    text = ''
      i3-msg -t get_tree | \
      jq '.nodes[] | .nodes[] | .nodes[] | select(.name=="__i3_scratch") | .floating_nodes[] | .nodes[] | .window,.name' | \
      sed 's/\"//g' | \
      paste - - -d ' ' | \
      ${super.dmenu.dmenu} | \
      cut -f1 -d ' '| \
      xargs -I "PID" i3-msg "[id=PID] scratchpad show"
    '';
  };
in "${scratchpad}/bin/dmenu-scratchpad"
