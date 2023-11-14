{ inputs, cell, config, ... }:
let
  inherit (inputs) nixpkgs;
in
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    customPaneNavigationAndResize = true;
    keyMode = "vi";
    plugins = with nixpkgs; [ ];
    tmuxp.enable = true;
    extraConfig = ''
      set -g status 2
      set -g status-format[1] ""
      set -g status-position top
      set -g default-terminal xterm
      set -g display-time 5000
      set -g focus-events on
      set -sg escape-time 10
      set -g renumber-windows on
      set -g default-terminal "screen-256color"
      set -sa terminal-overrides ',screen-256color:RGB'
      
      set -g status-style bg=terminal 
      set -g status-style fg=white
      set -g status-left "#[white]#S ~ "
      set -g status-right ""
      
      set -g status-justify 'left'
      set -g window-status-format "#{window_index}.#{window_name}"
      set -g window-status-style "bg=default"
      set -g window-status-current-format "#{window_index}.#{window_name}"
      set -g window-status-current-style fg=yellow
      set -g window-status-separator ' / '
      
      bind -T copy-mode-vi 'v' send -X begin-selection
      bind -T copy-mode-vi 'y' send -X copy-selection-and-cancel
      
      bind Tab choose-tree -sZ
      bind Enter new-session
      bind r source-file ~/.tmux.conf
      bind X confirm-before -p "Kill #S (y/n)?" "run-shell 'tmux switch-client -t space \\\; kill-session -t \"#S\"'"
      
      bind % split-window -h -c '#{pane_current_path}'  # Split panes horizontal
      bind '"' split-window -v -c '#{pane_current_path}'  # Split panes vertically
      
      set -g @yank_selection 'clipboard'
      bind BSpace last-window

      bind -n F1 switch-client -t F1
      bind -n F2 switch-client -t F2
      bind -n F3 switch-client -t F3
      bind -n F4 switch-client -t F4
      bind -n F5 switch-client -t F5
      bind -n F6 switch-client -t F6
      bind -n F7 switch-client -t F7
      bind -n F8 switch-client -t F8
      bind -n F9 switch-client -t F9
      bind -n F10 switch-client -t F10
      bind -n F11 switch-client -t F11
      bind -n F12 switch-client -t F12
    '';
  };
}
