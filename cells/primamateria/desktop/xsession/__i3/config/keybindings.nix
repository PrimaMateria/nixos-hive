{
  inputs,
  root,
}: let
  inherit (inputs) nixpkgs;
  inherit (root.props) mod modes menus workspace;
in {
  "${mod}+q" = "kill";
  "${mod}+Shift+c" = "reload";
  "${mod}+Shift+r" = "restart";
  "${mod}+f" = "fullscreen toggle";
  "${mod}+Shift+space" = "floating toggle";

  "${mod}+d" = "exec --no-startup-id ${menus.commands}";
  "${mod}+BackSpace" = "exec --no-startup-id ${menus.favorites}";

  "${mod}+r" = "mode ${modes.resize}";
  "${mod}+Shift+e" = "mode \"${modes.system}\"";

  "${mod}+h" = "focus left";
  "${mod}+j" = "focus down";
  "${mod}+k" = "focus up";
  "${mod}+l" = "focus right";
  "${mod}+a" = "focus parent";
  "${mod}+z" = "focus child";
  "${mod}+space" = "focus mode_toggle";

  "${mod}+Shift+h" = "move left";
  "${mod}+Shift+j" = "move down";
  "${mod}+Shift+k" = "move up";
  "${mod}+Shift+l" = "move right";

  "${mod}+m" = "layout tabbed";
  "${mod}+t" = "layout splith";
  "${mod}+F4" = "layout splitv";
  "${mod}+F5" = "layout stacked";
  "${mod}+F6" = "split horizontal, layout stacking";

  "${mod}+1" = "workspace number ${workspace 1}";
  "${mod}+2" = "workspace number ${workspace 2}";
  "${mod}+3" = "workspace number ${workspace 3}";
  "${mod}+4" = "workspace number ${workspace 4}";
  "${mod}+5" = "workspace number ${workspace 5}";
  "${mod}+6" = "workspace number ${workspace 6}";
  "${mod}+7" = "workspace number ${workspace 7}";
  "${mod}+8" = "workspace number ${workspace 8}";
  "${mod}+9" = "workspace number ${workspace 9}";
  "${mod}+0" = "workspace number ${workspace 0}";

  "${mod}+Shift+0" = "move container to workspace number ${workspace 0}";
  "${mod}+Shift+1" = "move container to workspace number ${workspace 1}";
  "${mod}+Shift+2" = "move container to workspace number ${workspace 2}";
  "${mod}+Shift+3" = "move container to workspace number ${workspace 3}";
  "${mod}+Shift+4" = "move container to workspace number ${workspace 4}";
  "${mod}+Shift+5" = "move container to workspace number ${workspace 5}";
  "${mod}+Shift+6" = "move container to workspace number ${workspace 6}";
  "${mod}+Shift+7" = "move container to workspace number ${workspace 7}";
  "${mod}+Shift+8" = "move container to workspace number ${workspace 8}";
  "${mod}+Shift+9" = "move container to workspace number ${workspace 9}";

  "${mod}+x" = "move scratchpad";
  "${mod}+Shift+x" = "exec ${menus.scratchpad}";

  "${mod}+minus" = "[class=\"Enpass\" title=\"^Enpass$\"] scratchpad show";
  "${mod}+equal" = "[class=\"chatgpt\"] scratchpad show";
}
