{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  config = {
    environment.systemPackages = with nixpkgs; [
      vim
      wget
      tzdata
    ];
  };
}
