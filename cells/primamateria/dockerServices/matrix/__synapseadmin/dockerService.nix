{
  super,
}: {
  synapse-admin = {
    # etkecc fork; the original awesometechnologies repo is no longer
    # maintained. Pinned by digest because upstream only publishes :latest.
    image = "ghcr.io/etkecc/synapse-admin@sha256:ce1eaf7d890f44c0e40896dcbee9e560484a5b6953ffd3deaf2ecc625a74dc25";
    container_name = "synapse-admin";
    restart = "unless-stopped";
    volumes = [
      "${super.config}:/home/sws/public/config.json:ro"
    ];
    networks = ["default" "traefik_net"];
    labels = [
      "traefik.enable=true"

      "traefik.http.middlewares.https_redirect.redirectscheme.scheme=https"
      "traefik.http.middlewares.https_redirect.redirectscheme.permanent=true"
      "traefik.http.routers.http-synapse-admin.entrypoints=http"
      "traefik.http.routers.http-synapse-admin.rule=Host(`synapse-admin.primamateria.ddns.net`)"
      "traefik.http.routers.http-synapse-admin.middlewares=https_redirect"

      "traefik.http.routers.https-synapse-admin.entrypoints=https"
      "traefik.http.routers.https-synapse-admin.rule=Host(`synapse-admin.primamateria.ddns.net`)"
      "traefik.http.routers.https-synapse-admin.tls=true"
      "traefik.http.routers.https-synapse-admin.tls.certresolver=le-ssl"
      "traefik.http.routers.https-synapse-admin.service=synapse-admin"

      # The image declares EXPOSE 80, but static-web-server runs as the
      # unprivileged sws user and actually binds 8080.
      "traefik.http.services.synapse-admin.loadbalancer.server.port=8080"
    ];
  };
}
