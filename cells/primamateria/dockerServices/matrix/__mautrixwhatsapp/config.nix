{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;
in
  nixpkgs.writeTextFile {
    name = "mautrix-whatsapp-config.yaml";
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
        address = "http://mautrix-whatsapp:29318";
        hostname = "0.0.0.0";
        port = 29318;
        id = "whatsapp";
        bot = {
          username = "whatsappbot";
          displayname = "WhatsApp bridge bot";
          avatar = "mxc://maunium.net/NeXNQarUbrlYBiPCpprYsRqr";
        };
        ephemeral_events = true;
        async_transactions = false;
        as_token = secrets.matrix.mautrixwhatsapp.as_token;
        hs_token = secrets.matrix.mautrixwhatsapp.hs_token;
        username_template = "whatsapp_{{.}}";
      };

      database = {
        type = "postgres";
        uri = "postgres://${secrets.matrix.synapse.postgres_user}:${secrets.matrix.synapse.postgres_password}@synapse-db/matrix_whatsapp?sslmode=disable";
      };

      matrix = {
        message_status_events = false;
        delivery_receipts = false;
        read_receipts = true;
        typing_notifications = false;
        msc4190 = false;
      };

      network = {
        os_name = "Mautrix-WhatsApp";
        browser_name = "Chrome";
        displayname_template = "{{if .PushName}}{{.PushName}}{{else if .BusinessName}}{{.BusinessName}}{{else}}{{.JID}}{{end}} (WhatsApp)";
        call_start_notices = true;
        identity_change_notices = false;
        history_sync = {
          backfill = false;
          media_requests = {
            auto_request_media = false;
          };
        };
      };

      bridge = {
        command_prefix = "!wa";
        personal_filtering_spaces = true;
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
