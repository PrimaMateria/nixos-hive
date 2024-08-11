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
      # TODO: enable and configure host matrix and some subpath
      "traefik.enable=false"
    ];
  };
}
