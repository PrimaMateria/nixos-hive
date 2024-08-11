{inputs}: let
  inherit (inputs) nixpkgs;
in
  nixpkgs.writeTextFile {
    name = "matrix.primamateria.ddns.net.log.config";
    text = builtins.toJSON {
      version = 1;
      formatters.precise.format = "%(asctime)s - %(name)s - %(lineno)d - %(levelname)s - %(request)s - %(message)s";
      handlers = {
        file = {
          class = "logging.handlers.TimedRotatingFileHandler";
          formatter = "precise";
          filename = "/var/log/synapse/synapse.log";
          when = "midnight";
          backupCount = 3;
          encoding = "utf8";
        };
        buffer = {
          class = "synapse.logging.handlers.PeriodicallyFlushingMemoryHandler";
          target = "file";
          capacity = 10;
          flushLevel = 30;
          period = 5;
        };
        console = {
          class = "logging.StreamHandler";
          formatter = "precise";
        };
      };
      loggers = {
        "synapse.storage.sql".level = "INFO";
        "shared_secret_authenticator".level = "INFO";
      };
      root = {
        level = "INFO";
        handlers = ["buffer"];
      };
      disable_existing_loggers = false;
    };
  }
