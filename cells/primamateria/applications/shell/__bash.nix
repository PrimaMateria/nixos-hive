{ ... }: {
  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "eza --time-style long-iso";
      ll = "ls -lha";
      cat = "bat -p";
      nvim = "nix run ~/dev/neovim-nix --";
      n = "cd ~/dev/nixos; nvim";
      nn = "cd ~/dev/neovim-nix; nvim";
    };
    initExtra = ''
      # \001 (^A) start non-visible characters
      # \002 (^B) end non-visible characters

      BLUE="\001$(tput setaf 4)\002"
      YELLOW="\001$(tput setaf 3)\002"
      RESET="\001$(tput sgr0)\002"

      PS1="''${BLUE}\w''${YELLOW}\$''${RESET} "

      export EDITOR=nvim
      export MANPAGER="less -R --use-color -Dd+y -Du+b"
    '';
  };
}
