{
  inputs,
  super,
}: let
  inherit (inputs) nixpkgs;
in {
  imports = [
    super.modules.bash
    super.modules.direnv
    super.modules.readline
  ];

  config = {
    home.packages = with nixpkgs; [
      unzip
    ];
  };
}
