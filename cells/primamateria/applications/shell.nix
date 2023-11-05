{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
in
{
  home.packages = with nixpkgs; [
    unzip
    htop
    exa
    bat
    tldr
    fzf
    entr
    translate-shell
    glow
    sc-im
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "exa --color automatic --time-style long-iso";
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

      export EDITOR=${pkgs.neovim}/bin/nvim
      export MANPAGER="less -R --use-color -Dd+y -Du+b"
      export NIXPKGS_ALLOW_UNFREE=1
      export OPENAI_API_KEY=${chatgptSecrets.apiKey}
      
      eval "$(zoxide init bash)"

      #test -z ''${TMUX} && tmux new-session -A -s space
    '';
  };
}
