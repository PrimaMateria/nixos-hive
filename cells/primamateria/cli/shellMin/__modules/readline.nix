{...}: {
  programs.readline = {
    enable = true;
    extraConfig = ''
      set colored-stats on
      set colored-completion-prefix on
      set show-all-if-ambiguous on
      set completion-ignore-case on
      set editing-mode vi
      set show-mode-in-prompt on
      set vi-ins-mode-string "i:"
      set vi-cmd-mode-string "n:"
    '';
  };
}
