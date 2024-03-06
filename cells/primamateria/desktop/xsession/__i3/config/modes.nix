{ root }:
let
  inherit (root.props) modes;
in
{
  "${modes.resize}" = {
    h = "resize shrink width 10 px or 10 ppt";
    j = "resize grow height 10 px or 10 ppt";
    k = "resize shrink height 10 px or 10 ppt";
    l = "resize grow width 10 px or 10 ppt";
    Escape = "mode default";
  };
  "${modes.system}" = {
    "Shift+s" = "exec --no-startup-id systemctl poweroff -i, mode default";
    e = "exec --no-startup-id i3-msg exit, mode default";
    s = "exec --no-startup-id systemctl suspend, mode default";
    r = "exec --no-startup-id systemctl reboot, mode default";
    Escape = "mode default";
  };
}
