{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;

  dockerCompose = nixpkgs.writeTextFile {
    name = "calibreweb-docker-compose.yaml";
    text = builtins.toJSON {
      networks = {
        traefik_net = {external = true;};
      };

      volumes = {
        calibreweb-config = null;
      };

      services = {
        calibreweb = {
          image = "linuxserver/calibre-web:latest";
          container_name = "calibreweb";
          restart = "unless-stopped";
          environment = [
            "PUID=1000"
            "PGID=1000"
            "TZ=Europe/Berlin"
            "DOCKER_MODS=linuxserver/mods:universal-calibre"
          ];
          volumes = [
            "calibreweb-config:/config"
            "/home/primamateria/books:/books"
          ];
          networks = ["default" "traefik_net"];
          labels = [
            "traefik.enable=true"
            "traefik.http.middlewares.https_redirect_calibreweb.redirectscheme.scheme=https"
            "traefik.http.middlewares.https_redirect_calibreweb.redirectscheme.permanent=true"
            "traefik.http.routers.http-calibreweb.entrypoints=http"
            "traefik.http.routers.http-calibreweb.rule=Host(`calibre.primamateria.ddns.net`)"
            "traefik.http.routers.http-calibreweb.middlewares=https_redirect_calibreweb"
            "traefik.http.routers.https-calibreweb.entrypoints=https"
            "traefik.http.routers.https-calibreweb.rule=Host(`calibre.primamateria.ddns.net`)"
            "traefik.http.routers.https-calibreweb.tls=true"
            "traefik.http.routers.https-calibreweb.tls.certresolver=le-ssl"
            "traefik.http.routers.https-calibreweb.service=calibreweb"
            "traefik.http.services.calibreweb.loadbalancer.server.port=8083"
          ];
        };
      };
    };
  };
in {
  home.packages = [
    (nixpkgs.writeShellApplication {
      name = "run-calibreweb";
      text = ''
        echo "Composing calibre-web"
        docker compose -p calibreweb --file ${dockerCompose} up -d
      '';
    })
  ];
}
