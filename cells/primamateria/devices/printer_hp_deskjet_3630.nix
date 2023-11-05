{ inputs, cell }:
{
  config = {
    services.printing.enable = true;
    services.printing.drivers = [ pkgs.hplipWithPlugin ];

    services.avahi.enable = true;
    services.avahi.nssmdns = true;
    services.avahi.reflector = true;

    hardware.sane.enable = true;
    hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];
    hardware.sane.netConf = "192.168.178.31";
  };
}
