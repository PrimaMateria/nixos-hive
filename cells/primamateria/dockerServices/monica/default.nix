{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;

  dockerCompose = nixpkgs.writeTextFile {
    name = "monica-docker-compose.yaml";
    text = builtins.toJSON {
      version = "2.4";
      volumes = {
        data = null;
        mysql = null;
      };
      services = with secrets.monicaServer; {
        monica = {
          labels = [
            "traefik.enable=true"
            "traefik.http.middlewares.monicaM1.compress=true"
            "traefik.http.middlewares.monicaM2.headers.browserXssFilter=true"
            "traefik.http.middlewares.monicaM2.headers.forceSTSHeader=true"
            "traefik.http.middlewares.monicaM2.headers.frameDeny=true"
            "traefik.http.middlewares.monicaM2.headers.referrerPolicy=no-referrer-when-downgrade"
            "traefik.http.middlewares.monicaM2.headers.stsSeconds=31536000"
            "traefik.http.routers.monica.entrypoints=https"
            "traefik.http.routers.monica.tls=true"
            "traefik.http.routers.monica.tls.certresolver=le-ssl"
            "traefik.http.routers.monica.middlewares=monicaM1,monicaM2"
            "traefik.http.routers.monica.rule=Host(`monica.primamateria.ddns.net`)"
          ];
          image = "monica:apache";
          container_name = "monica";
          restart = "always";
          volumes = [
            "data:/var/www/html/storage"
          ];
          environment = {
            APP_KEY = "base64:a+phGiDzEk8M/kLVnhL4qXgE6cUCwS4tUolYkoJi1mo=";
            APP_ENV = "production";
            DB_HOST = "db";
            DB_DATABASE = "monica";
            DB_USERNAME = dbUsername;
            DB_PASSWORD = dbPassword;
            LOG_CHANNEL = "stderr";
            CACHE_DRIVER = "database";
            SESSION_DRIVER = "database";
            QUEUE_DRIVER = "sync";
            MAIL_MAILER = "smtp";
            MAIL_HOST = mailHost;
            MAIL_PORT = mailPort;
            MAIL_USERNAME = mailUsername;
            MAIL_PASSWORD = mailPassword;
            MAIL_FROM_ADDRESS = mailUsername;
            MAIL_FROM_NAME = "Homeserver Monica";
            MAIL_REPLY_TO_ADDRESS = mailUsername;
            MAIL_REPLY_TO_NAME = "Homeserver Monica";
          };
        };

        db = {
          image = "mariadb:11";
          environment = {
            MYSQL_RANDOM_ROOT_PASSWORD = true;
            MYSQL_DATABASE = "monica";
            MYSQL_USER = dbUsername;
            MYSQL_PASSWORD = dbPassword;
          };
          volumes = [
            "mysql:/var/lib/mysql"
          ];
          restart = "always";
          labels = [
            "traefik.enable=false"
          ];
        };
      };
    };
  };
in {
  home.packages = [
    (nixpkgs.writeShellApplication
      {
        name = "run-monica";
        text = ''
          echo "Composing monica"
          docker compose -p monica --file ${dockerCompose} up -d
        '';
      })
  ];
}
