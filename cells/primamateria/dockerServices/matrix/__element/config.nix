{inputs}: let
  inherit (inputs) nixpkgs;
in
  nixpkgs.writeTextFile {
    name = "element-config.json";
    text = builtins.toJSON {
      default_server_config = {
        "m.homeserver" = {
          base_url = "https://matrix.primamateria.ddns.net";
          server_name = "matrix.primamateria.ddns.net";
        };
      };

      brand = "Element";
      showLabsSettings = true;
      disable_guests = true;

      roomDirectory = {
        servers = [
          "matrix.org"
          "gitter.im"
          "libera.chat"
        ];
      };

      # Synapse has presence disabled, so do not let the client ask for it.
      enable_presence_by_hs_url = {
        "https://matrix.primamateria.ddns.net" = false;
        "https://matrix.org" = false;
        "https://matrix-client.matrix.org" = false;
      };

      features = {};
    };
  }
