{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  config = {
    documentation.man.generateCaches = true;
    environment.systemPackages = with nixpkgs; [
      vim
      wget
      tzdata
    ];
  };
}
