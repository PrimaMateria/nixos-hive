{root}: let
  inherit (root.props) palette;
in {
  background = "${palette.colorBackground}";
  focused = {
    border = "${palette.colorDrab}";
    childBorder = "${palette.colorDrab}";
    background = "${palette.colorBackground}";
    text = "${palette.colorProminent}";
    indicator = "${palette.colorDrab}";
  };
  focusedInactive = {
    border = "${palette.colorDrab}";
    childBorder = "${palette.colorDrab}";
    background = "${palette.colorBackground}";
    text = "${palette.colorProminent}";
    indicator = "${palette.colorDominant}";
  };
  unfocused = {
    border = "${palette.colorDrab}";
    childBorder = "${palette.colorDrab}";
    background = "${palette.colorBackground}";
    text = "${palette.colorDominant}";
    indicator = "${palette.colorDrab}";
  };
  urgent = {
    border = "${palette.colorAlert}";
    childBorder = "${palette.colorAlert}";
    background = "${palette.colorBackground}";
    text = "${palette.colorDominant}";
    indicator = "${palette.colorAlert}";
  };
  placeholder = {
    border = "${palette.colorDrab}";
    childBorder = "${palette.colorProminent}";
    background = "${palette.colorBackground}";
    text = "${palette.colorDominant}";
    indicator = "${palette.colorDominant}";
  };
}
