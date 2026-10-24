{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;
in
  nixpkgs.writeTextFile {
    name = "mautrix-discord-config.yaml";
    text = builtins.toJSON {
      homeserver = {
        address = "http://synapse:8008";
        domain = "matrix.primamateria.ddns.net";
        software = "standard";
        status_endpoint = null;
        message_send_checkpoint_endpoint = null;
        async_media = false;
        websocket = false;
        ping_interval_seconds = 0;
      };

      appservice = {
        address = "http://mautrix-discord:29334";
        hostname = "0.0.0.0";
        port = 29334;
        database = {
          type = "postgres";
          uri = "postgres://${secrets.matrix.synapse.postgres_user}:${secrets.matrix.synapse.postgres_password}@synapse-db/matrix_discord?sslmode=disable";
        };
        id = "discord";
        bot = {
          username = "discordbot";
          displayname = "Discord bridge bot";
          avatar = "mxc://maunium.net/nIdEykemnwdisvHbpxflpDlC";
        };
        ephemeral_events = true;
        async_transactions = false;
        as_token = secrets.matrix.mautrixdiscord.as_token;
        hs_token = secrets.matrix.mautrixdiscord.hs_token;
      };

      bridge = {
        username_template = "discord_{{.}}";
        displayname_template = "{{if .Webhook}}Webhook{{else}}{{or .GlobalName .Username}}{{if .Bot}} (bot){{end}}{{end}}";
        channel_name_template = "{{if or (eq .Type 3) (eq .Type 4)}}{{.Name}}{{else}}#{{.Name}}{{end}}";
        guild_name_template = "{{.Name}}";
        command_prefix = "!discord";
        delivery_receipts = false;
        message_status_events = false;
        message_error_notices = true;
        delete_guild_on_leave = true;
        federate_rooms = true;
        permissions = {
          "*" = "relay";
          "matrix.primamateria.ddns.net" = "user";
          "@primamateria:matrix.primamateria.ddns.net" = "admin";
        };
      };

      logging = {
        min_level = "warn";
        writers = [
          {
            type = "stdout";
            format = "pretty-colored";
          }
        ];
      };
    };
  }
