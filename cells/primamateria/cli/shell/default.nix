{inputs}: let
  inherit (cell) cli;
  inherit (inputs) nixpkgs;
in {
  imports = [cli.shellMin];
  config = {
    home.packages = with nixpkgs; [
      unzip
      eza
      bat
      tldr
      fzf
      entr
      translate-shell
      glow
      chatblade
    ];

    programs.bash = {
      enable = true;
      shellAliases = {
        ls = "eza --time-style long-iso";
        cat = "bat -p";
        nvim = "nix run ~/dev/neovim-nix --";
      };
    };
  };
}
