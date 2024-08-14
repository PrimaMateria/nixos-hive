{
  inputs,
  cell,
  super,
}: {
  matrix-wechat = {
    hostname = "matrix-wechat";
    container_name = "matrix-wechat";
    image = "lxduo/matrix-wechat:2";
    restart = "unless-stopped";
    depends_on = {
      synapse = {
        condition = "service_healthy";
      };
    };
    volumes = [
      # TODO: configs passed to data, do I need to persist rest of data as volume?
      "${super.config}:/data/config.yaml"
      "${super.registration}:/data/registration.yaml"
      # "./matrix-wechat:/data"
    ];
    # networks = [
    #   "matrix-net"
    # ];
    labels = [
      "traefik.enable=true"

      "traefik.http.routers.https-matrix-wechat.entrypoints=https"
      "traefik.http.routers.https-matrix-wechat.rule=Host(`matrix.primamateria.ddns.net`) && PathPrefix(`/_wechat/`)"
      "traefik.http.routers.https-matrix-wechat.tls=true"
      "traefik.http.routers.https-matrix-wechat.tls.certresolver=le-ssl"
      "traefik.http.routers.https-matrix-wechat.service=matrix-wechat"

      "traefik.http.services.matrix-wechat.loadbalancer.server.port=20002"
    ];
  };
}
