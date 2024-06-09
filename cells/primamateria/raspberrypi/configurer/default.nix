{
  inputs,
  cell,
  super,
}: let
  inherit (inputs) nixpkgs;
in {
  home.packages = [
    (nixpkgs.writeShellApplication
      {
        name = "rpi5-configure";
        text = ''
          ${super.boot}
          ${super.docker}
        '';
      })
  ];
}
