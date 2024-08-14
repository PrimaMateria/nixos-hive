{
  cell,
  inputs,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;

  # This script is intended for Docker and not a NixOS host. Therefore, we do
  # not create it with writeShellApplication to avoid the hashbang pointing to
  # the Nix store.
  initScript = nixpkgs.writeTextFile {
    name = "synapsedb-init.sh";
    text = ''
      #!/bin/sh
      createdb -U ${secrets.matrix.synapse.postgres_user} -O ${secrets.matrix.synapse.postgres_user} matrix_wechat
    '';
    executable = true;
  };
in {
  synapse-db = {
    image = "postgres:alpine";
    container_name = "synapse-db";
    restart = "unless-stopped";
    ports = ["5432:5432"];
    environment = [
      "POSTGRES_USER=${secrets.matrix.synapse.postgres_user}"
      "POSTGRES_PASSWORD=${secrets.matrix.synapse.postgres_password}"
      "POSTGRES_INITDB_ARGS=--encoding=UTF-8 --lc-collate=C --lc-ctype=C"
    ];
    volumes = [
      "${initScript}:/docker-entrypoint-initdb.d/20-create_db.sh:ro"
      "synapse-db-data:/var/lib/postgresql/data"
    ];
    healthcheck = {
      test = ["CMD-SHELL" "pg_isready -U ${secrets.matrix.synapse.postgres_user}"];
      interval = "5s";
      timeout = "5s";
      retries = 5;
    };
    labels = [
      "traefik.enable=false"
    ];
  };
}
