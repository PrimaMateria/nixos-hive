{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;
in
  nixpkgs.writeTextFile {
    name = "mautrix-discord-registration.yaml";
    text = builtins.toJSON {
      id = "discord";
      url = "http://mautrix-discord:29334";
      as_token = secrets.matrix.mautrixdiscord.as_token;
      hs_token = secrets.matrix.mautrixdiscord.hs_token;
      rate_limited = false;
      sender_localpart = "discordbot";
      namespaces = {
        users = [
          {
            exclusive = true;
            regex = "@discord_.*";
          }
          {
            exclusive = true;
            regex = "@discordbot:matrix\\.primamateria\\.ddns\\.net$";
          }
        ];
        aliases = [];
        rooms = [];
      };
    };
  }
