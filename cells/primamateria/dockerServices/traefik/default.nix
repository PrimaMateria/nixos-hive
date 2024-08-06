{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;

  dynamicConfiguration = nixpkgs.writeTextFile {
    name = "traefik-dynamic.yaml";
    text = builtins.toJSON {
      tls.stores.default.defaultCertificate = {
        certFile = "/etc/ssl/certs/primamateria_ddns_net.pem";
        keyFile = "/etc/ssl/private/primamateria_ddns_net.key";
      };
    };
  };

  dockerCompose = nixpkgs.writeTextFile {
    name = "traefik-docker-compose.yaml";
    text = builtins.toJSON {
      version = "2.4";
      volumes = {
        traefik-letsencrypt = null;
        traefik-tmp = null;
      };
      services = {
        traefik = {
          image = "traefik:v3.0";
          container_name = "traefik";
          network_mode = "host";
          ports = [
            "80:80"
            "8080:8080"
            "443:443"
          ];
          volumes = [
            "/var/run/docker.sock:/var/run/docker.sock"
            "traefik-tmp:/tmp"
            "traefik-letsencrypt:/letsencrypt"
            "${dynamicConfiguration}:/etc/traefik/dynamic.yaml:ro"
            "${secrets.primamateriaDdnsNet}/primamateria_ddns_net.pem:/etc/ssl/certs/primamateria_ddns_net.pem:ro"
            "${secrets.primamateriaDdnsNet}/primamateria_ddns_net_nopassword.key:/etc/ssl/private/primamateria_ddns_net.key:ro"
          ];
          command = [
            "--api.insecure=true"
            "--providers.docker=true"
            "--entryPoints.http.address=:80"
            "--entryPoints.https.address=:443"
            "--entryPoints.federation.address=:8448"
            "--entryPoints.http.http.redirections.entryPoint.to=https"
            "--entryPoints.http.http.redirections.entryPoint.scheme=https"
            "--providers.file.filename=/etc/traefik/dynamic.yaml"
            "--certificatesresolvers.le-ssl.acme.email=matus.benko@gmail.com"
            "--certificatesresolvers.le-ssl.acme.storage=/letsencrypt/acme.json"
            "--certificatesresolvers.le-ssl.acme.httpChallenge.entryPoint=http"
            "--log.filepath=/tmp/traefik.log"
            "--log.level=DEBUG"
          ];
          labels = [
            "traefik.enable=false"
          ];
        };
      };
    };
  };
in {
  home.packages = [
    (nixpkgs.writeShellApplication
      {
        name = "run-traefik";
        text = ''
          echo "Composing traefik"
          docker compose -p traefik --file ${dockerCompose} up -d
        '';
      })
  ];
}
