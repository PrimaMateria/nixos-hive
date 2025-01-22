{
  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "ls --color=always";
      ll = "ls -lha";
    };
    initExtra = ''
      # \001 (^A) start non-visible characters
      # \002 (^B) end non-visible characters

      BLUE="\001$(tput setaf 4)\002"
      YELLOW="\001$(tput setaf 3)\002"
      RESET="\001$(tput sgr0)\002"

      PS1="''${BLUE}\w''${YELLOW}\$''${RESET} "

      export EDITOR="nix run ~/dev/neovim-nix#neovim.base --"
      export MANPAGER="less -R --use-color -Dd+y -Du+b"
    '';
  };
}
