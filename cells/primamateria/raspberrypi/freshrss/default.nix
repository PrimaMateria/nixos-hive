{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;

  dockerCompose = nixpkgs.writeTextFile {
    name = "freshrss-docker-compose.yaml";
    text = builtins.toJSON {
      version = "2.4";
      volumes = {
        data = null;
        extensions = null;
      };
      services = with secrets.freshrssServer; {
        freshrss = {
          labels = [
            "traefik.enable=true"
            "traefik.http.middlewares.freshrssM1.compress=true"
            "traefik.http.middlewares.freshrssM2.headers.browserXssFilter=true"
            "traefik.http.middlewares.freshrssM2.headers.forceSTSHeader=true"
            "traefik.http.middlewares.freshrssM2.headers.frameDeny=true"
            "traefik.http.middlewares.freshrssM2.headers.referrerPolicy=no-referrer-when-downgrade"
            "traefik.http.middlewares.freshrssM2.headers.stsSeconds=31536000"
            "traefik.http.routers.freshrss.entrypoints=https"
            "traefik.http.routers.freshrss.tls=true"
            "traefik.http.middlewares.freshrssM3.stripprefix.prefixes=/freshrss"
            "traefik.http.routers.freshrss.middlewares=freshrssM1,freshrssM2,freshrssM3"
            "traefik.http.routers.freshrss.rule=PathPrefix(`/freshrss`)"
          ];
          image = "freshrss/freshrss";
          container_name = "freshrss";
          restart = "unless-stopped";
          logging.options.max-size = "10m";
          volumes = [
            "data:/var/www/FreshRSS/data"
            "extensions:/var/www/FreshRSSS/extensions"
          ];
          environment = {
            TZ = "Europe/Berlin";
            CRON_MIN = "2,32";
            FRESHRSS_ENV = "development";
            LISTEN = "0.0.0.0:80";
            ADMIN_EMAIL = adminEmail;
            ADMIN_PASSWORD = adminPassword;
            ADMIN_API_PASSWORD = adminApiPassword;
            FRESHRSS_INSTALL = ''
              --api-enabled
              --base-url https://primamateria.ddns.net/freshrss
              --default_user primamateria
              --language en
            '';
            FRESHRESS_USER = ''
              --api-password ${adminApiPassword}
              --email ${adminEmail}
              --language en
              --password ${adminPassword}
              --user primamateria
            '';
          };
        };
      };
    };
  };
in {
  home.packages = [
    (nixpkgs.writeShellApplication
      {
        name = "run-freshrss";
        text = ''
          echo "Composing freshrss"
          docker compose -p freshrss --file ${dockerCompose} up -d
        '';
      })
  ];
}
