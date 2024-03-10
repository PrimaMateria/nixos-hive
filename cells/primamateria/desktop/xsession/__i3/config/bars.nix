{ root, inputs }:
let
  inherit (inputs.nixpkgs) lib;
  inherit (root.props) statusBars palette;
in
[
  {
    statusCommand = lib.traceVal statusBars.main;
    position = "top";
    fonts = {
      size = 12.0;
    };
    colors = {
      background = "${palette.colorBackgroundBar}";
      statusline = "${palette.colorDominant}";
      separator = "${palette.colorDrab}";
      focusedWorkspace = {
        border = "${palette.colorBackgroundBar}";
        background = "${palette.colorBackgroundBar}";
        text = "${palette.colorProminent}";
      };
      activeWorkspace = {
        border = "${palette.colorBackgroundBar}";
        background = "${palette.colorBackgroundBar}";
        text = "${palette.colorProminent}";
      };
      inactiveWorkspace = {
        border = "${palette.colorBackgroundBar}";
        background = "${palette.colorBackgroundBar}";
        text = "${palette.colorDominant}";
      };
      urgentWorkspace = {
        border = "${palette.colorBackgroundBar}";
        background = "${palette.colorBackgroundBar}";
        text = "${palette.colorAlert}";
      };
      bindingMode = {
        border = "${palette.colorBackgroundBar}";
        background = "${palette.colorProminent}";
        text = "${palette.colorBackgroundBar}";
      };
    };
  }
]
