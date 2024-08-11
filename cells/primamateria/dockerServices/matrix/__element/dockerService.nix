{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;
in {
  element = {
    image = "vectorim/element-web:latest";
    container_name = "element";
    restart = "unless-stopped";
    volumes = [
      "${super.config}:/app/config.json:ro"
    ];
    environment = [
      "BASE_URL=/element"
      "PUBLIC_URL=/element"
    ];
    labels = [
      "traefik.enable=true"

      "traefik.http.middlewares.https_redirect.redirectscheme.scheme=https"
      "traefik.http.middlewares.https_redirect.redirectscheme.permanent=true"
      "traefik.http.routers.http-element.entrypoints=http"
      "traefik.http.routers.http-element.rule=Host(`element.primamateria.ddns.net`)"
      "traefik.http.routers.http-element.middlewares=https_redirect"

      "traefik.http.middlewares.element_stripprefix.stripprefix.prefixes=element"
      "traefik.http.routers.https-element.entrypoints=https"
      "traefik.http.routers.https-element.rule=Host(`element.primamateria.ddns.net`)"
      "traefik.http.routers.https-element.middlewares=element_stripprefix"
      "traefik.http.routers.https-element.tls=true"
      "traefik.http.routers.https-element.tls.certresolver=le-ssl"
      "traefik.http.routers.https-element.service=element"
      "traefik.http.services.element.loadbalancer.server.port=80"
    ];
  };
}
