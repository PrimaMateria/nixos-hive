{cell}: let
  inherit (cell) secrets;
  ssid = "FRITZ!Box 7590 CG";
in {
  networking.hosts = {
    "192.168.2.67" = ["homeServer"];
  };

  # Home Wi-Fi for whichever Wi-Fi stack the host runs: NetworkManager on the
  # desktops (Noctalia's network widget talks to it), wpa_supplicant elsewhere.
  imports = [
    ({
      config,
      lib,
      ...
    }: let
      nm = config.networking.networkmanager.enable;
    in {
      networking.wireless.networks = lib.mkIf (!nm) {
        ${ssid}.psk = secrets.homeWifiPassword;
      };

      networking.networkmanager.ensureProfiles.profiles = lib.mkIf nm {
        home-wifi = {
          connection = {
            id = ssid;
            type = "wifi";
          };
          wifi = {
            inherit ssid;
            mode = "infrastructure";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = secrets.homeWifiPassword;
          };
          ipv4.method = "auto";
          ipv6.method = "auto";
        };
      };
    })
  ];
}
