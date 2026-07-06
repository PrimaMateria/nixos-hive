{inputs}: let
  inherit (cell) cli;
  inherit (inputs) nixpkgs llm-agents;
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
      lf
      llm-agents.packages.${nixpkgs.system}.copilot-cli
      llm-agents.packages.${nixpkgs.system}.claude-code
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
        nvim = "~/dev/neovim-nix/run/nvim-base";
        nvim-blog = "~/dev/neovim-nix/run/nvim-blog";
        nvim-c = "~/dev/neovim-nix/run/nvim-c";
        nvim-light = "~/dev/neovim-nix/run/nvim-light";
        nvim-pmwebdev = "~/dev/neovim-nix/run/nvim-pmwebdev";
        nvim-puml = "~/dev/neovim-nix/run/nvim-puml";
        nvim-python = "~/dev/neovim-nix/run/nvim-python";
        nvim-rust = "~/dev/neovim-nix/run/nvim-rust";
        nvim-web = "~/dev/neovim-nix/run/nvim-web";
      };
    };
  };
}
