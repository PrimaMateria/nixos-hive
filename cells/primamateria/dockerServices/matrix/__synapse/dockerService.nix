{super}: {
  synapse = {
    image = "matrixdotorg/synapse:latest";
    container_name = "synapse";
    restart = "unless-stopped";
    volumes = [
      "synapse-data:/data"
      "synapse-log:/var/log/synapse"
      "${super.config}:/etc/synapse/synapse.yaml:ro"
      "${super.logging}:/matrix.primamateria.ddns.net.log.config:ro"
      "${super.bridgeWechat.authenticator}/shared_secret_authenticator.py:/usr/local/lib/python3.11/site-packages/shared_secret_authenticator.py:ro"
      "${super.bridgeWechat.registration}:/wechat-registration.yaml:ro"
    ];
    environment = [
      "SYNAPSE_CONFIG_PATH=/etc/synapse/synapse.yaml"
    ];
    depends_on = [
      "synapse-db"
    ];
    labels = [
      "traefik.enable=true"

      "traefik.http.middlewares.https_redirect.redirectscheme.scheme=https"
      "traefik.http.middlewares.https_redirect.redirectscheme.permanent=true"
      "traefik.http.routers.http-synapse.entrypoints=http"
      "traefik.http.routers.http-synapse.rule=Host(`matrix.primamateria.ddns.net`)"
      "traefik.http.routers.http-synapse.middlewares=https_redirect"

      "traefik.http.routers.https-synapse.entrypoints=https"
      "traefik.http.routers.https-synapse.rule=Host(`matrix.primamateria.ddns.net`)"
      "traefik.http.routers.https-synapse.tls=true"
      "traefik.http.routers.https-synapse.tls.certresolver=le-ssl"
      "traefik.http.routers.https-synapse.service=synapse"

      "traefik.http.routers.federation-synapse.entrypoints=federation"
      "traefik.http.routers.federation-synapse.rule=Host(`matrix.primamateria.ddns.net`)"
      "traefik.http.routers.federation-synapse.tls=true"
      "traefik.http.routers.federation-synapse.tls.certresolver=le-ssl"
      "traefik.http.routers.federation-synapse.service=synapse"

      "traefik.http.services.synapse.loadbalancer.server.port=8008"
    ];
  };
}
