{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
in
{
  imports = [
    ./__bash.nix
    ./__direnv.nix
    ./__readline.nix
  ];

  config = {
    home.packages = with nixpkgs; [
      unzip
      htop
      eza
      bat
      tldr
      fzf
      entr
      translate-shell
      glow
    ];
  };
}
