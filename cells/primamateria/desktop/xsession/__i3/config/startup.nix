{ root }:
let
  inherit (root.props) workspace;
in
[
  { command = "alacritty"; notification = false; }
  { command = "Enpass"; notification = false; }
  { command = "i3-msg workspace '${workspace 1}'"; notification = false; }
]
