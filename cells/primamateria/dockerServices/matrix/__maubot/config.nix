{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;
in
  nixpkgs.writeTextFile {
    name = "maubot-config.yaml";
    # JSON is valid YAML, and maubot parses this file as YAML.
    text = builtins.toJSON {
      database = "postgresql://${secrets.matrix.synapse.postgres_user}:${secrets.matrix.synapse.postgres_password}@synapse-db/matrix_maubot";
      crypto_database = "default";
      crypto_db_pickle_key = "mau.crypto";
      database_opts = {
        min_size = 1;
        max_size = 10;
      };

      plugin_directories = {
        upload = "/data/plugins";
        load = ["/data/plugins"];
        trash = "/data/trash";
      };

      plugin_databases = {
        sqlite = "/data/dbs";
        # Each plugin instance gets its own postgres schema in matrix_maubot.
        postgres = "default";
        postgres_max_conns_per_plugin = 3;
        postgres_opts = {};
      };

      server = {
        hostname = "0.0.0.0";
        port = 29316;
        public_url = "https://maubot.primamateria.ddns.net";
        ui_base_path = "/_matrix/maubot";
        plugin_base_path = "/_matrix/maubot/plugin/";
        # Rewritten to /opt/maubot/frontend by the image entrypoint.
        override_resource_path = false;
        unshared_secret = secrets.matrix.maubot.unshared_secret;
      };

      homeservers = {
        "matrix.primamateria.ddns.net" = {
          url = "http://synapse:8008";
          secret = secrets.matrix.synapse.registration_shared_secret;
        };
      };

      # "root" is special and cannot hold a password, so log in as primamateria.
      admins = {
        root = "";
        primamateria = secrets.matrix.maubot.admin_password;
      };

      api_features = {
        login = true;
        plugin = true;
        plugin_upload = true;
        instance = true;
        instance_database = true;
        client = true;
        client_proxy = true;
        client_auth = true;
        dev_open = true;
        log = true;
      };

      logging = {
        version = 1;
        formatters.normal.format = "[%(asctime)s] [%(levelname)s@%(name)s] %(message)s";
        handlers.console = {
          class = "logging.StreamHandler";
          formatter = "normal";
        };
        loggers = {
          maubot.level = "INFO";
          mau.level = "INFO";
          aiohttp.level = "WARNING";
        };
        root = {
          level = "INFO";
          handlers = ["console"];
        };
      };
    };
  }
