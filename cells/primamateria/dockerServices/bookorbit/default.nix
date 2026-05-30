{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;

  dockerCompose = nixpkgs.writeTextFile {
    name = "bookorbit-docker-compose.yaml";
    text = builtins.toJSON {
      networks = {
        traefik_net = {external = true;};
      };

      volumes = {
        bookorbit-data = null;
        bookorbit-db-data = null;
      };

      services = {
        bookorbit = {
          image = "ghcr.io/bookorbit/bookorbit:latest";
          container_name = "bookorbit";
          restart = "unless-stopped";
          environment = [
            "NODE_ENV=production"
            "PORT=3000"
            "POSTGRES_HOST=bookorbit-db"
            "POSTGRES_PORT=5432"
            "POSTGRES_USER=bookorbit"
            "POSTGRES_PASSWORD=${secrets.bookorbit.postgresPassword}"
            "POSTGRES_DB=bookorbit"
            "JWT_SECRET=${secrets.bookorbit.jwtSecret}"
            "SETUP_BOOTSTRAP_TOKEN=${secrets.bookorbit.setupBootstrapToken}"
            "APP_URL=https://books.primamateria.ddns.net"
            "CLIENT_URL=https://books.primamateria.ddns.net"
          ];
          volumes = [
            "bookorbit-data:/data"
            "/home/primamateria/books:/books"
          ];
          depends_on = ["bookorbit-db"];
          networks = ["default" "traefik_net"];
          labels = [
            "traefik.enable=true"
            "traefik.http.middlewares.https_redirect_bookorbit.redirectscheme.scheme=https"
            "traefik.http.middlewares.https_redirect_bookorbit.redirectscheme.permanent=true"
            "traefik.http.routers.http-bookorbit.entrypoints=http"
            "traefik.http.routers.http-bookorbit.rule=Host(`books.primamateria.ddns.net`)"
            "traefik.http.routers.http-bookorbit.middlewares=https_redirect_bookorbit"
            "traefik.http.routers.https-bookorbit.entrypoints=https"
            "traefik.http.routers.https-bookorbit.rule=Host(`books.primamateria.ddns.net`)"
            "traefik.http.routers.https-bookorbit.tls=true"
            "traefik.http.routers.https-bookorbit.tls.certresolver=le-ssl"
            "traefik.http.routers.https-bookorbit.service=bookorbit"
            "traefik.http.services.bookorbit.loadbalancer.server.port=3000"
          ];
        };

        bookorbit-db = {
          image = "pgvector/pgvector:pg16";
          container_name = "bookorbit-db";
          restart = "unless-stopped";
          environment = [
            "POSTGRES_USER=bookorbit"
            "POSTGRES_PASSWORD=${secrets.bookorbit.postgresPassword}"
            "POSTGRES_DB=bookorbit"
          ];
          volumes = [
            "bookorbit-db-data:/var/lib/postgresql/data"
          ];
          healthcheck = {
            test = ["CMD-SHELL" "pg_isready -U bookorbit"];
            interval = "5s";
            timeout = "5s";
            retries = 5;
          };
          labels = ["traefik.enable=false"];
        };
      };
    };
  };
in {
  home.packages = [
    (nixpkgs.writeShellApplication {
      name = "run-bookorbit";
      text = ''
        echo "Composing bookorbit"
        docker compose -p bookorbit --file ${dockerCompose} up -d
      '';
    })
  ];
}
