{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;
in
  nixpkgs.writeTextFile {
    name = "heisenbridge-registration.yaml";
    text = builtins.toJSON {
      id = "heisenbridge";
      url = "http://heisenbridge:9898";
      as_token = secrets.matrix.heisenbridge.as_token;
      hs_token = secrets.matrix.heisenbridge.hs_token;
      rate_limited = false;
      sender_localpart = "heisenbridge";
      namespaces = {
        users = [
          {
            exclusive = true;
            regex = "@heisenbridge_.*";
          }
        ];
        aliases = [];
        rooms = [];
      };
    };
  }
