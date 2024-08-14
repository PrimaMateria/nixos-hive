{super}: {
  matrix-wechat-agent = {
    hostname = "matrix-wechat-agent";
    container_name = "matrix-wechat-agent";
    image = "lxduo/matrix-wechat-agent:latest";
    restart = "unless-stopped";
    depends_on = ["matrix-wechat"];
    volumes = [
      "${super.config}:/home/user/matrix-wechat-agent/configure.yaml"
    ];
    labels = [
      "traefik.enable=false"
    ];
  };
}
