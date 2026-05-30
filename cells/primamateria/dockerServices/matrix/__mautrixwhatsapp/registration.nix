{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;
in
  nixpkgs.writeTextFile {
    name = "mautrix-whatsapp-registration.yaml";
    text = builtins.toJSON {
      id = "whatsapp";
      url = "http://mautrix-whatsapp:29318";
      as_token = secrets.matrix.mautrixwhatsapp.as_token;
      hs_token = secrets.matrix.mautrixwhatsapp.hs_token;
      rate_limited = false;
      sender_localpart = "whatsappbot";
      namespaces = {
        users = [
          {
            exclusive = true;
            regex = "@whatsapp_.*:matrix\\.primamateria\\.ddns\\.net$";
          }
          {
            exclusive = true;
            regex = "@whatsappbot:matrix\\.primamateria\\.ddns\\.net$";
          }
        ];
        aliases = [];
        rooms = [];
      };
    };
  }
