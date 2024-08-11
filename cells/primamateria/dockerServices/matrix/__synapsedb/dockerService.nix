{cell}: let
  inherit (cell) secrets;
in {
  synapse-db = {
    image = "postgres:alpine";
    container_name = "synapse-db";
    restart = "unless-stopped";
    environment = [
      "POSTGRES_USER=${secrets.matrix.synapse.postgres_user}"
      "POSTGRES_PASSWORD=${secrets.matrix.synapse.postgres_password}"
      "POSTGRES_INITDB_ARGS=--encoding=UTF-8 --lc-collate=C --lc-ctype=C"
    ];
    volumes = [
      "synapse-db-data:/var/lib/postgresql/data"
    ];
    labels = [
      "traefik.enable=false"
    ];
  };
}
