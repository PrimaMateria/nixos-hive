{inputs}: let
  inherit (inputs) nixpkgs;
in
  nixpkgs.writeTextFile {
    name = "synapse-admin-config.json";
    text = builtins.toJSON {
      # Pin the UI to our homeserver so the login form cannot be pointed at
      # someone else's server.
      restrictBaseUrl = "https://matrix.primamateria.ddns.net";

      # The bridge bots are appservice-managed; flag them so the user list does
      # not offer to edit them like regular accounts.
      asManagedUsers = [
        "^@heisenbridge_.*:matrix\\.primamateria\\.ddns\\.net$"
        "^@whatsapp_.*:matrix\\.primamateria\\.ddns\\.net$"
        "^@whatsappbot:matrix\\.primamateria\\.ddns\\.net$"
        "^@discord_.*:matrix\\.primamateria\\.ddns\\.net$"
        "^@discordbot:matrix\\.primamateria\\.ddns\\.net$"
      ];
    };
  }
