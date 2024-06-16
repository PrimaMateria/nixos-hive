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
            "traefik.http.middlewares.freshrssM3.stripprefix.prefixes=/freshrss"
            "traefik.http.routers.freshrss.middlewares=freshrssM3"
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
              --base-url http://rpi5/freshrss
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
