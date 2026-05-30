{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;

  dockerCompose = nixpkgs.writeTextFile {
    name = "wetty-docker-compose.yaml";
    text = builtins.toJSON {
      networks = {
        traefik_net = {external = true;};
      };

      services = {
        wetty = {
          image = "wettyoss/wetty";
          container_name = "wetty";
          restart = "unless-stopped";
          command = [
            "--ssh-host" "host.docker.internal"
            "--ssh-port" "22"
            "--ssh-user" "primamateria"
            "--port" "3000"
            "--base" "/"
            "--ssh-command" "tmux attach-session || tmux new-session"
          ];
          extra_hosts = ["host.docker.internal:host-gateway"];
          networks = ["default" "traefik_net"];
          labels = [
            "traefik.enable=true"
            "traefik.http.middlewares.https_redirect_wetty.redirectscheme.scheme=https"
            "traefik.http.middlewares.https_redirect_wetty.redirectscheme.permanent=true"
            "traefik.http.routers.http-wetty.entrypoints=http"
            "traefik.http.routers.http-wetty.rule=Host(`term.primamateria.ddns.net`)"
            "traefik.http.routers.http-wetty.middlewares=https_redirect_wetty"
            "traefik.http.routers.https-wetty.entrypoints=https"
            "traefik.http.routers.https-wetty.rule=Host(`term.primamateria.ddns.net`)"
            "traefik.http.routers.https-wetty.tls=true"
            "traefik.http.routers.https-wetty.tls.certresolver=le-ssl"
            "traefik.http.routers.https-wetty.service=wetty"
            "traefik.http.services.wetty.loadbalancer.server.port=3000"
          ];
        };
      };
    };
  };
in {
  home.packages = [
    (nixpkgs.writeShellApplication {
      name = "run-wetty";
      text = ''
        echo "Composing wetty"
        docker compose -p wetty --file ${dockerCompose} up -d
      '';
    })
  ];
}
