{
  inputs,
  cells,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;

  karakeepEnv = nixpkgs.writeTextFile {
    name = "karakeep-env";
    text = nixpkgs.lib.generators.toKeyValue {} {
      karakeep_VERSION = "release";
      NEXTAUTH_SECRET = secrets.karakeep.nextAuthSecret;
      MEILI_MASTER_KEY = secrets.karakeep.meiliMasterKey;
      NEXTAUTH_URL = "https://karakeep.primamateria.ddns.net";
      OPENAI_API_KEY = secrets.openAiApiKey;
    };
  };

  dockerCompose = nixpkgs.writeTextFile {
    name = "karakeep-docker-compose.yaml";
    text = builtins.toJSON {
      networks = {
        traefik_net = {external = true;};
      };

      volumes = {
        meilisearch = null;
        data = null;
      };

      services = {
        web = {
          image = "ghcr.io/karakeep-app/karakeep:0.34.1";
          restart = "unless-stopped";
          networks = ["default" "traefik_net"];
          volumes = ["data:/data"];
          env_file = ["${karakeepEnv}"];
          environment = {
            MEILI_ADDR = "http://meilisearch:7700";
            BROWSER_WEB_URL = "http://chrome:9222";
            OPENAI_API_KEY = secrets.openAiApiKey;
            DATA_DIR = "/data";
            DISABLE_SIGNUPS = "true";
          };
          labels = [
            "traefik.enable=true"
            "traefik.http.middlewares.karakeepM1.compress=true"
            "traefik.http.middlewares.karakeepM2.headers.browserXssFilter=true"
            "traefik.http.middlewares.karakeepM2.headers.forceSTSHeader=true"
            "traefik.http.middlewares.karakeepM2.headers.frameDeny=true"
            "traefik.http.middlewares.karakeepM2.headers.referrerPolicy=no-referrer-when-downgrade"
            "traefik.http.middlewares.karakeepM2.headers.stsSeconds=31536000"
            "traefik.http.routers.karakeep.entrypoints=https"
            "traefik.http.routers.karakeep.tls=true"
            "traefik.http.routers.karakeep.tls.certresolver=le-ssl"
            "traefik.http.routers.karakeep.middlewares=karakeepM1,karakeepM2"
            "traefik.http.routers.karakeep.rule=Host(`karakeep.primamateria.ddns.net`)"
            "traefik.http.services.karakeep.loadbalancer.server.port=3000"
          ];
        };

        chrome = {
          # gcr.io/zenika-hub is gone: anonymous pulls fail with "requires
          # billing to be enabled", so the old image survives only as a local
          # layer cache and would break on any recreate. karakeep publishes
          # its own browser image now; this mirrors upstream's compose.
          # Pinned by digest because it only ships a floating :release tag.
          image = "ghcr.io/karakeep-app/karakeep-chrome@sha256:4ad61127638dd27bfe685222787c5780dd1d083d23a7658c39af657775814c44";
          restart = "unless-stopped";
          init = true;
          command = [
            "--disable-gpu"
            "--disable-dev-shm-usage"
            "--hide-scrollbars"
            "--disable-blink-features=AutomationControlled"
            "--window-size=1440,900"
          ];
          labels = ["traefik.enable=false"];
        };

        meilisearch = {
          image = "getmeili/meilisearch:v1.41.0";
          restart = "unless-stopped";
          env_file = ["${karakeepEnv}"];
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
        name = "run-karakeep";
        text = ''
          echo "Composing karakeep"
          docker compose -p karakeep --file ${dockerCompose} up -d
        '';
      })
  ];
}
