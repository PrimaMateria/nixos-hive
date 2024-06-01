{inputs}: let
  inherit (inputs) nixpkgs;
in {
  imports = [
    ./__modules/bash.nix
    ./__modules/direnv.nix
    ./__modules/readline.nix
  ];

  config = {
    home.packages = with nixpkgs; [
      unzip
    ];
  };
}
