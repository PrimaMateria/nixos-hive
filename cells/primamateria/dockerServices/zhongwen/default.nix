{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;

  dockerCompose = nixpkgs.writeTextFile {
    name = "zhongwen-docker-compose.yaml";
    text = builtins.toJSON {
      version = "2.4";
      services = {
        zhongwen = {
          labels = [
            "traefik.enable=true"
            "traefik.http.middlewares.zhongwenM1.compress=true"
            "traefik.http.middlewares.zhongwenM2.headers.browserXssFilter=true"
            "traefik.http.middlewares.zhongwenM2.headers.forceSTSHeader=true"
            "traefik.http.middlewares.zhongwenM2.headers.frameDeny=true"
            "traefik.http.middlewares.zhongwenM2.headers.referrerPolicy=no-referrer-when-downgrade"
            "traefik.http.middlewares.zhongwenM2.headers.stsSeconds=31536000"
            "traefik.http.routers.zhongwen.entrypoints=https"
            "traefik.http.routers.zhongwen.tls=true"
            "traefik.http.routers.zhongwen.tls.certresolver=le-ssl"
            "traefik.http.routers.zhongwen.middlewares=zhongwenM1,zhongwenM2"
            "traefik.http.routers.zhongwen.rule=Host(`zhongwen.primamateria.ddns.net`)"
          ];
          image = "zhongwen";
          container_name = "zhongwen";
          restart = "unless-stopped";
        };
      };
    };
  };
in {
  home.packages = [
    (nixpkgs.writeShellApplication
      {
        name = "run-zhongwen";
        text = ''
          echo "Composing zhongwen"
          docker compose -p zhongwen --file ${dockerCompose} up -d
        '';
      })
  ];
}
