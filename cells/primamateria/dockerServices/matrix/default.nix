{
  inputs,
  super,
}: let
  inherit (inputs) nixpkgs;

  dockerCompose = nixpkgs.writeTextFile {
    name = "matrix-docker-compose.yaml";
    text = builtins.toJSON {
      volumes = {
        synapse-data = null;
        synapse-db-data = null;
        synapse-log = null;
      };

      services = super.synapse // super.element;
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
