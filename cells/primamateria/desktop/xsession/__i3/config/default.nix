{ root }:
let
  inherit (root.props) workspace mod;
in
{
  modifier = mod;
  fonts = {
    names = [ "CaskaydiaCove Nerd Font Mono" ];
    size = 10.0;
  };

  gaps = {
    inner = 5;
  };

  workspaceLayout = "default";
  defaultWorkspace = "workspace ${workspace 1}";

  floating = {
    modifier = mod;
    border = 1;
    titlebar = true;
  };

  focus = {
    followMouse = false;
  };
}
