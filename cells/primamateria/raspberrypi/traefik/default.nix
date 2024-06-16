{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;

  dockerCompose = nixpkgs.writeTextFile {
    name = "traefik-docker-compose.yaml";
    text = builtins.toJSON {
      version = "3";
      services = {
        traefik = {
          image = "traefik:v3.0";
          network_mode = "host";
          command = "--api.insecure=true --providers.docker";
          ports = [
            "80:80"
            "8080:8080"
          ];
          volumes = [
            "/var/run/docker.sock:/var/run/docker.sock"
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
