{
  super,
}: {
  maubot = {
    image = "dock.mau.dev/maubot/maubot:v0.6.0";
    container_name = "maubot";
    restart = "unless-stopped";
    volumes = [
      "maubot-data:/data"
      "${super.config}:/seed/config.yaml:ro"
    ];
    # Refresh the config from the store on every start, then hand over to the
    # image's own entrypoint, which fixes up paths and drops privileges.
    entrypoint = "/bin/sh";
    command = [
      "-c"
      "cp /seed/config.yaml /data/config.yaml && exec /opt/maubot/docker/run.sh"
    ];
    networks = ["default" "traefik_net"];
    depends_on = {
      synapse.condition = "service_healthy";
      synapse-db.condition = "service_healthy";
    };
    labels = [
      "traefik.enable=true"

      "traefik.http.middlewares.https_redirect.redirectscheme.scheme=https"
      "traefik.http.middlewares.https_redirect.redirectscheme.permanent=true"
      "traefik.http.routers.http-maubot.entrypoints=http"
      "traefik.http.routers.http-maubot.rule=Host(`maubot.primamateria.ddns.net`)"
      "traefik.http.routers.http-maubot.middlewares=https_redirect"

      "traefik.http.routers.https-maubot.entrypoints=https"
      "traefik.http.routers.https-maubot.rule=Host(`maubot.primamateria.ddns.net`)"
      "traefik.http.routers.https-maubot.tls=true"
      "traefik.http.routers.https-maubot.tls.certresolver=le-ssl"
      "traefik.http.routers.https-maubot.service=maubot"

      "traefik.http.services.maubot.loadbalancer.server.port=29316"
    ];
  };
}
