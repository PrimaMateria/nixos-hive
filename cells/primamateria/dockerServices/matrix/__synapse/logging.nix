{inputs}: let
  inherit (inputs) nixpkgs;
in
  nixpkgs.writeTextFile {
    name = "matrix.primamateria.ddns.net.log.config";
    text = builtins.toJSON {
      version = 1;
      formatters.precise.format = "%(asctime)s - %(name)s - %(lineno)d - %(levelname)s - %(request)s - %(message)s";
      handlers = {
        console = {
          class = "logging.StreamHandler";
          formatter = "precise";
        };
      };
      loggers = {
        "synapse.storage.sql".level = "INFO";
      };
      root = {
        level = "INFO";
        handlers = ["console"];
      };
      disable_existing_loggers = false;
    };
  }
