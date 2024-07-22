{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  imports = [
    ./__theme.nix
    ./__vifmrc.nix
  ];

  config = {
    home.packages = with nixpkgs; [
      vifm
    ];
  };
}
