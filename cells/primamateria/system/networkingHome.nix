{cell}: let
  inherit (cell) secrets;
in {
  networking.hosts = {
    "192.168.178.67" = ["homeServer"];
  };
  networking.wireless.networks = {
    "FRITZ!Box 7590 CG" = {
      psk = secrets.homeWifiPassword;
    };
  };
}
