{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
in
{
  config = {
    services.printing.enable = true;
    services.printing.drivers = [ nixpkgs.hplipWithPlugin ];

    services.avahi.enable = true;
    services.avahi.nssmdns = true;
    services.avahi.reflector = true;

    hardware.sane.enable = true;
    hardware.sane.extraBackends = [ nixpkgs.hplipWithPlugin ];
    hardware.sane.netConf = "192.168.178.31";
  };
}
