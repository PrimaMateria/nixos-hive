{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;

  dockerCompose = nixpkgs.writeTextFile {
    name = "suwayomi.yaml";
    text = builtins.toJSON {
      version = "2.4";
      volumes = {
        files = null;
      };
      services = with secrets.suwayomi; {
        suwayomi = {
          labels = [
            "traefik.enable=true"
            "traefik.http.middlewares.suwayomiM1.compress=true"
            "traefik.http.middlewares.suwayomiM2.headers.browserXssFilter=true"
            "traefik.http.middlewares.suwayomiM2.headers.forceSTSHeader=true"
            "traefik.http.middlewares.suwayomiM2.headers.frameDeny=true"
            "traefik.http.middlewares.suwayomiM2.headers.referrerPolicy=no-referrer-when-downgrade"
            "traefik.http.middlewares.suwayomiM2.headers.stsSeconds=31536000"
            "traefik.http.routers.suwayomi.entrypoints=https"
            "traefik.http.routers.suwayomi.tls=true"
            "traefik.http.routers.suwayomi.tls.certresolver=le-ssl"
            "traefik.http.routers.suwayomi.middlewares=suwayomiM1,suwayomiM2"
            "traefik.http.routers.suwayomi.rule=Host(`suwayomi.primamateria.ddns.net`)"
            "traefik.http.services.suwayomi.loadbalancer.server.port=4567"
          ];
          image = "ghcr.io/suwayomi/suwayomi-server:preview";
          container_name = "suwayomi";
          restart = "on-failure:3";
          volumes = [
            "files:/home/suwayomi/.local/share/Tachidesk"
          ];
          environment = {
            TZ = "Europe/Berlin";
            FLARESOLVERR_ENABLED = "true";
            FLARESOLVERR_URL = "http://flaresolverr:8191";
            AUTH_MODE = "ui_login";
            AUTH_USERNAME = username;
            AUTH_PASSWORD = password;
          };
        };

        flaresolverr = {
          image = "ghcr.io/thephaseless/byparr:latest";
          container_name = "flaresolverr";
          labels = ["traefik.enable=false"];
          environment = {
            TZ = "Europe/Berlin";
          };
          restart = "unless-stopped";
        };
      };
    };
  };
in {
  home.packages = [
    (nixpkgs.writeShellApplication
      {
        name = "run-suwayomi";
        text = ''
          echo "Composing suwayomi"
          docker compose -p suwayomi --file ${dockerCompose} up -d
        '';
      })
  ];
}
