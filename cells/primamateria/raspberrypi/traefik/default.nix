{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;

  tls = nixpkgs.writeTextFile {
    name = "traefik-tls.yaml";
    text = builtins.toJSON {
      options.default = {
        minVersion = "VersionTLS12";
        sniStrict = true;
        cipherSuites = [
          "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384"
          "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
          "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
          "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
          "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305"
          "TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305"
          "TLS_AES_128_GCM_SHA256"
          "TLS_AES_256_GCM_SHA384"
          "TLS_CHACHA20_POLY1305_SHA256"
        ];
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
            "traefik-letsencrypt:/etc/traefik/acme"
            "${tls}:/etc/traefik/tls.yaml:ro"
          ];
          command = [
            "--api.insecure=true"
            "--providers.docker=true"
            "--entryPoints.http.address=:80"
            "--entryPoints.https.address=:443"
            "--entryPoints.http.http.redirections.entryPoint.to=https"
            "--entryPoints.http.http.redirections.entryPoint.scheme=https"
            "--certificatesResolvers.letsEncrypt.acme.storage=/etc/traefik/acme/acme.json"
            "--certificatesResolvers.letsEncrypt.acme.email=matus.benko@gmail.com"
            "--certificatesResolvers.letsEncrypt.acme.tlsChallenge=true"
            "--providers.file.filename=/etc/traefik/tls.yaml"
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
