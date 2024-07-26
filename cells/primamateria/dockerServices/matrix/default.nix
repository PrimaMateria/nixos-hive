{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;

  synapseConfiguration = nixpkgs.writeTextFile {
    name = "synapse-config.yaml";
    text = builtins.toJSON {
      server_name =  "primamateria.ddns.net";
      pid_file = "/data/homeserver.pid";
      listeners = [
        { 
          port = 8008;
          tls = false;
          type = "http";
          x_forwarded = true;
          resources = [
            {
              names = ["client", "federation"];
              compress: false;
            }
          ];
        }
      ];

      database = {
        name = "sqlite3";
        args = {
          database = "/data/homeserver.db";
        };
      };

      log_config = "/data/primamateria.ddns.net.log.config";
      media_store_path = "/data/media_store";
      registration_shared_secret = secrets.matrix.synapse.registration_shared_secret;
      reports_stats = true;
      macaroon_secret_key = secrets.matrix.synapse.macaroon_secret_key;
      form_secret = secrets.matrix.synpase.form_secret;
      signing_key_path= "/data/primamateria.ddns.net.signing.key"; # TODO
      trusted_key_servers = [
      { server_name = "matrix.org"; }
      ];
    };
  };

  elementConfiguration = nixpkgs.writeTextFile {
    name = "element-config.json"
    text = builtins.toJSON {
      # TODO
    };
  };

  dockerCompose = nixpkgs.writeTextFile {
    name = "matrix-docker-compose.yaml";
    text = builtins.toJSON {
      version = "2.4";

      volumes = {
        synapse-data = null;
        db-data = null;
      };

      services = {
        synapse = {
          image = "matrixdotorg/synapse";
          container_name = "matrix-synapse";
          restart = "unless-stopped";
          volumes = [
            "synapse-data:/data"
            "${synapseConfiguration}:/etc/synapse/synapse.yaml:ro"
          ];
          environment = [
            "SYNAPSE_CONFIG_PATH=/etc/synapse/synapse.yaml"
          ];
          depends_on = [
            "db"
          ];
          labels = [
            "traefik.enable=true"
            "traefik.http.routers.http-synapse.entryPoints=http"
            "traefik.http.routers.http-synapse.rule=Host(`primamateria.ddns.net`)"
            "traefik.http.middlewares.https_redirect.redirectscheme.scheme=https"
            "traefik.http.middlewares.https_redirect.resirectscheme.permanent=true"
            "traefik.http.routers.http-synapse.middlewares=https_redirect"
            "traefik.http.routers.https-synapse.entryPoint=https"
            "traefik.http.routers.https-synapse.rule=Host(`primamateria.ddns.net`)"
            "traefik.http.routers.https-synapse.service=synapse"
            "traefik.http.routers.https-synapse.tls=true"
            "traefik.http.services.synapse.loadbalancer.server.port=8080" # ?
            "traefik.http.routers.https-synapse.tls.certResolver=le-ssl" # ?
          ];
        };

        db = {
          image = "postgres/alpine";
          container_name = "matrix-db";
          restart = "unless-stopped";
          environment = [
            # TODO
            "POSTGRES_USER=synapse"
            "POSTGRES_PASSWORD=synapse"
            "POSTGRES_INITDB_ARGS=--encoding=UTF-8 --lc-collate=C --lc-ctype=C"
          ];
          volumes = [
            "synapse-db-data:/var/lib/postgresql/data"
          ];
        };

        # element = {
        #   image = "vectorim/element-web";
        #   container_name = "matrix-element";
        #   restart = "unless-stopped";
        #   volumes = [
        #     "${elementConfiguration}:/app/config.json:ro"
        #   ];
        #   labels = [
        #     # TODO
        #   ];
        # };
      };
    };
  };
in {
  home.packages = [
    (nixpkgs.writeShellApplication
      {
        name = "run-matrix";
        text = ''
          echo "Composing matrix"
          docker compose -p matrix --file ${dockerCompose} up -d
        '';
      })
  ];
}
