{
  inputs,
  super,
}: let
  inherit (inputs) nixpkgs;

  dockerCompose = nixpkgs.writeTextFile {
    name = "matrix-docker-compose.yaml";
    text = builtins.toJSON {
      networks = {
        traefik_net = {external = true;};
      };

      volumes = {
        synapse-data = null;
        synapse-db-data = null;
        heisenbridge-data = null;
        mautrix-whatsapp-data = null;
        mautrix-discord-data = null;
      };

      services =
        super.synapse.dockerService
        // super.synapsedb.dockerService
        // super.element.dockerService
        // super.synapseadmin.dockerService
        // super.heisenbridge.dockerService
        // super.mautrixwhatsapp.dockerService
        // super.mautrixdiscord.dockerService;
    };
  };
in {
  home.packages = [
    (nixpkgs.writeShellApplication
      {
        name = "run-matrix";
        text = ''
          echo "Composing matrix"
          docker compose -p matrix --file ${dockerCompose} up -d
        '';
      })
  ];
}
