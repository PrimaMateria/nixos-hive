{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;

  dockerCompose = nixpkgs.writeTextFile {
    name = "strix.yaml";
    text = builtins.toJSON {
      # Strix - IP camera stream discovery.
      # Requires host networking for LAN scanning (ARP/mDNS/port probing),
      # so it is NOT behind Traefik. Reach it at http://<homeserver-LAN-IP>:4567
      services = {
        strix = {
          image = "eduard256/strix:latest";
          container_name = "strix";
          network_mode = "host";
          restart = "unless-stopped";
          environment = {
            STRIX_LISTEN = ":4567";
          };
        };
      };
    };
  };
in {
  home.packages = [
    (nixpkgs.writeShellApplication
      {
        name = "run-strix";
        text = ''
          echo "Composing strix"
          docker compose -p strix --file ${dockerCompose} up -d
        '';
      })
  ];
}
