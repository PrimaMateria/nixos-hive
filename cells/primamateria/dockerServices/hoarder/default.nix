{
  inputs,
  cells,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;

  hoarderEnv = nixpkgs.writeTextFile {
    name = "hoarder-env";
    text = nixpkgs.lib.generators.toKeyValue {} {
      HOARDER_VERSION = "release";
      NEXTAUTH_SECRET = secrets.hoarder.nextAuthSecret;
      MEILI_MASTER_KEY = secrets.hoarder.meiliMasterKey;
      NEXTAUTH_URL = "https://hoarder.primamateria.ddns.net";
      OPENAI_API_KEY = secrets.openAiApiKey;
    };
  };

  dockerCompose = nixpkgs.writeTextFile {
    name = "hoarder-docker-compose.yaml";
    text = builtins.toJSON {
      volumes = {
        meilisearch = null;
        data = null;
      };

      services = {
        web = {
          image = "ghcr.io/hoarder-app/hoarder:release";
          restart = "unless-stopped";
          volumes = ["data:/data"];
          env_file = ["${hoarderEnv}"];
          environment = {
            MEILI_ADDR = "http://meilisearch:7700";
            BROWSER_WEB_URL = "http://chrome:9222";
            OPENAI_API_KEY = secrets.openAiApiKey;
            DATA_DIR = "/data";
            DISABLE_SIGNUPS = "true";
          };
          labels = [
            "traefik.enable=true"
            "traefik.http.middlewares.hoarderM1.compress=true"
            "traefik.http.middlewares.hoarderM2.headers.browserXssFilter=true"
            "traefik.http.middlewares.hoarderM2.headers.forceSTSHeader=true"
            "traefik.http.middlewares.hoarderM2.headers.frameDeny=true"
            "traefik.http.middlewares.hoarderM2.headers.referrerPolicy=no-referrer-when-downgrade"
            "traefik.http.middlewares.hoarderM2.headers.stsSeconds=31536000"
            "traefik.http.routers.hoarder.entrypoints=https"
            "traefik.http.routers.hoarder.tls=true"
            "traefik.http.routers.hoarder.tls.certresolver=le-ssl"
            "traefik.http.routers.hoarder.middlewares=hoarderM1,hoarderM2"
            "traefik.http.routers.hoarder.rule=Host(`hoarder.primamateria.ddns.net`)"
            "traefik.http.services.hoaerder.loadbalancer.server.port=3000"
          ];
        };

        chrome = {
          image = "gcr.io/zenika-hub/alpine-chrome:123";
          restart = "unless-stopped";
          command = [
            "--no-sandbox"
            "--disable-gpu"
            "--disable-dev-shm-usage"
            "--remote-debugging-address=0.0.0.0"
            "--remote-debugging-port=9222"
            "--hide-scrollbars"
          ];
          labels = ["traefik.enable=false"];
        };

        meilisearch = {
          image = "getmeili/meilisearch:v1.11.1";
          restart = "unless-stopped";
          env_file = ["${hoarderEnv}"];
          environment = {
            MEILI_NO_ANALYTICS = "true";
          };
          volumes = ["meilisearch:/meili_data"];
          labels = ["traefik.enable=false"];
        };
      };
    };
  };
in {
  home.packages = [
    (nixpkgs.writeShellApplication
      {
        name = "run-hoarder";
        text = ''
          echo "Composing hoarder"
          docker compose -p hoarder --file ${dockerCompose} up -d
        '';
      })
  ];
}
