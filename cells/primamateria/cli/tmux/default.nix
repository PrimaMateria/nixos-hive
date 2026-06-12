{
  inputs,
  cell,
  config,
  ...
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;

  utils = import ./__utils.nix {inherit lib;};

  cfg = config.primamateria.cli.tmux;
in {
  config = {
    xdg.configFile = utils.generateTmuxpConfigs cfg.sessions;

    programs.bash.shellAliases = {
      tmux-load = "tmuxp load ${utils.generateTmuxpLoadArgs cfg.sessions}";
    };

    programs.tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      customPaneNavigationAndResize = true;
      keyMode = "vi";
      mouse = true;
      plugins = with nixpkgs; [];
      tmuxp.enable = true;
      extraConfig = ''
        set -g status 2
        set -g status-format[1] ""

        set -g status-position top
        set -g display-time 5000
        set -g focus-events on
        set -sg escape-time 10
        set -g renumber-windows on
        set -g default-terminal "screen-256color"
        set -sa terminal-overrides ',screen-256color:RGB'

        set -g status-style bg=terminal
        set -g status-style fg=white
        set -g status-left "#[white][#H] #S ~  "
        set -g status-left-length 40
        set -g status-right "#{?client_prefix,#[reverse] ^B #[noreverse],}#{?pane_in_mode,#[reverse] Copy #[noreverse],}"

        set -g status-justify 'left'
        set -g window-status-format "#{window_index}.#{window_name}"
        set -g window-status-style "bg=default"
        set -g window-status-current-format "#{window_index}.#{window_name}"
        set -g window-status-current-style fg=yellow
        set -g window-status-separator ' / '

        bind -T copy-mode-vi 'v' send -X begin-selection
        bind -T copy-mode-vi 'y' send -X copy-selection-and-cancel

        bind Tab choose-tree -sZ
        bind Enter new-session -s 'F#{e|+:1,#{s/\$//:#{next_session_id}}}'
        bind X confirm-before -p "Kill #S (y/n)?" "run-shell 'tmux switch-client -p \\\; kill-session -t \"#S\"'"

        bind % split-window -h -c '#{pane_current_path}'
        bind '"' split-window -v -c '#{pane_current_path}'

        is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?nvim?x?)(diff)?$'"
        bind -n C-w if-shell "$is_vim" "send-keys C-w" "switch-client -T navigator"
        bind -T navigator h select-pane -L
        bind -T navigator j select-pane -D
        bind -T navigator k select-pane -U
        bind -T navigator l select-pane -R

        set -g history-limit 50000
        set -g pane-base-index 1
        bind BSpace last-window

        bind -n F1 if-shell 'tmux has-session -t F1' 'switch-client -t F1'
        bind -n F2 if-shell 'tmux has-session -t F2' 'switch-client -t F2'
        bind -n F3 if-shell 'tmux has-session -t F3' 'switch-client -t F3'
        bind -n F4 if-shell 'tmux has-session -t F4' 'switch-client -t F4'
        bind -n F5 if-shell 'tmux has-session -t F5' 'switch-client -t F5'
        bind -n F6 if-shell 'tmux has-session -t F6' 'switch-client -t F6'
        bind -n F7 if-shell 'tmux has-session -t F7' 'switch-client -t F7'
        bind -n F8 if-shell 'tmux has-session -t F8' 'switch-client -t F8'
        bind -n F9 if-shell 'tmux has-session -t F9' 'switch-client -t F9'
        bind -n F10 if-shell 'tmux has-session -t F10' 'switch-client -t F10'
        bind -n F11 if-shell 'tmux has-session -t F11' 'switch-client -t F11'
        bind -n F12 if-shell 'tmux has-session -t F12' 'switch-client -t F12'
      '';
    };
  };
}
