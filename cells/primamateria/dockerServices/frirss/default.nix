{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;

  host = "frirss.primamateria.ddns.net";

  # FreshRSS joins traefik_net under its service name, so FriRSS reaches the
  # Google Reader API over the shared network instead of hairpinning out
  # through the WAN and back in via traefik.
  freshrssPublic = "https://freshrss.primamateria.ddns.net";
  freshrssInternal = "http://freshrss:80";

  dockerCompose = nixpkgs.writeTextFile {
    name = "frirss-docker-compose.yaml";
    text = builtins.toJSON {
      version = "2.4";
      networks = {
        traefik_net = {external = true;};
      };
      volumes = {
        data = null;
        redis = null;
      };
      services = {
        frirss = {
          networks = ["default" "traefik_net"];
          labels = [
            "traefik.enable=true"
            "traefik.http.middlewares.frirssM1.compress=true"
            "traefik.http.middlewares.frirssM2.headers.browserXssFilter=true"
            "traefik.http.middlewares.frirssM2.headers.forceSTSHeader=true"
            "traefik.http.middlewares.frirssM2.headers.frameDeny=true"
            "traefik.http.middlewares.frirssM2.headers.referrerPolicy=no-referrer-when-downgrade"
            "traefik.http.middlewares.frirssM2.headers.stsSeconds=31536000"
            "traefik.http.routers.frirss.entrypoints=https"
            "traefik.http.routers.frirss.tls=true"
            "traefik.http.routers.frirss.tls.certresolver=le-ssl"
            "traefik.http.routers.frirss.middlewares=frirssM1,frirssM2"
            "traefik.http.routers.frirss.rule=Host(`${host}`)"
            "traefik.http.services.frirss.loadbalancer.server.port=80"
          ];
          image = "ghcr.io/fripix/frirss:1.7.0";
          container_name = "frirss";
          restart = "unless-stopped";
          depends_on = ["redis"];
          volumes = [
            "data:/app/data"
          ];
          environment = {
            TZ = "Europe/Berlin";
            NODE_ENV = "production";
            FRIRSS_DATA_DIR = "/app/data";
            FRIRSS_BASE_URL = "https://${host}";
            # Anti-SSRF allowlist. Without it the backend refuses the internal
            # FreshRSS address and connecting fails with POST /api/proxy 403.
            PROXY_INTERNAL_HOSTS = "freshrss";
            # Whichever FreshRSS URL is typed into the setup form, the backend
            # talks to the container directly.
            PROXY_REWRITES = "${freshrssPublic}=${freshrssInternal}";
            # Caches extracted full-text articles instance-wide and keeps the
            # article lists warm; without it every device re-extracts.
            REDIS_URL = "redis://redis:6379";
            CACHE_SYNC_INTERVAL = "15";
          };
        };

        redis = {
          image = "redis:8.2-alpine";
          container_name = "frirss-redis";
          restart = "unless-stopped";
          volumes = [
            "redis:/data"
          ];
          labels = ["traefik.enable=false"];
        };
      };
    };
  };
in {
  home.packages = [
    (nixpkgs.writeShellApplication
      {
        name = "run-frirss";
        text = ''
          echo "Composing frirss"
          docker compose -p frirss --file ${dockerCompose} pull
          docker compose -p frirss --file ${dockerCompose} up -d
        '';
      })
  ];
}
