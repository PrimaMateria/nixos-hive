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
      btop
      jq
      lazydocker
      aichat
      lf
    ];

    programs.nushell = {
      enable = true;
    };

    programs.bash = {
      enable = true;
      shellAliases = {
        ls = nixpkgs.lib.mkForce "eza --time-style long-iso";
        cat = "bat -p";
        top = "btop";
        nvim = "nix run ~/dev/neovim-nix#neovim.base --";
        nvim-web = "nix run ~/dev/neovim-nix#neovim.web --";
        nvim-puml = "nix run ~/dev/neovim-nix#neovim.puml --";
        nvim-blog = "nix run ~/dev/neovim-nix#neovim.blog --";
      };
    };
  };
}
