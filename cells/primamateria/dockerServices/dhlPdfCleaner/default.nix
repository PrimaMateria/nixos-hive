{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;

  dockerCompose = nixpkgs.writeTextFile {
    name = "dhlpdfcleaner-docker-compose.yaml";
    text = builtins.toJSON {
      version = "2.4";
      services = {
        dhlpdfcleaner = {
          labels = [
            "traefik.enable=true"
            "traefik.http.middlewares.dhlpdfcleanerM1.compress=true"
            "traefik.http.middlewares.dhlpdfcleanerM2.headers.browserXssFilter=true"
            "traefik.http.middlewares.dhlpdfcleanerM2.headers.forceSTSHeader=true"
            "traefik.http.middlewares.dhlpdfcleanerM2.headers.frameDeny=true"
            "traefik.http.middlewares.dhlpdfcleanerM2.headers.referrerPolicy=no-referrer-when-downgrade"
            "traefik.http.middlewares.dhlpdfcleanerM2.headers.stsSeconds=31536000"
            "traefik.http.routers.dhlpdfcleaner.entrypoints=https"
            "traefik.http.routers.dhlpdfcleaner.tls=true"
            "traefik.http.routers.dhlpdfcleaner.tls.certresolver=le-ssl"
            "traefik.http.routers.dhlpdfcleaner.middlewares=dhlpdfcleanerM1,dhlpdfcleanerM2"
            "traefik.http.routers.dhlpdfcleaner.rule=Host(`dhlpdfcleaner.primamateria.ddns.net`)"
          ];
          image = "dhlpdfcleaner";
          container_name = "dhlpdfcleaner";
          restart = "unless-stopped";
        };
      };
    };
  };
in {
  home.packages = [
    (nixpkgs.writeShellApplication
      {
        name = "run-dhlpdfcleaner";
        text = ''
          echo "Composing dhlpdfcleaner"
          docker compose -p dhlpdfcleaner --file ${dockerCompose} up -d
        '';
      })
  ];
}
