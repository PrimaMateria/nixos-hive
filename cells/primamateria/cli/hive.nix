{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
  src = "$HOME/dev/nixos-hive";
in
{
  home.packages = [
    (nixpkgs.writeShellApplication {
      name = "hive-reload-home";
      text = ''
        nix build "${src}#homeConfigurations.primamateria-$HOSTNAME.activationPackage"
        "${src}/result/activate"
      '';
    })

    (nixpkgs.writeShellApplication {
      name = "hive-reload-system";
      text = ''
        sudo nixos-rebuild switch --flake "${src}#primamateria-$HOSTNAME"
      '';
    })

    (nixpkgs.writeShellApplication {
      name = "hive-reload";
      text = ''
        hive-reload-system
        hive-reload-home
      '';
    })

    (nixpkgs.writeShellApplication {
      name = "hive-update";
      text = ''
        nix flake update "${src}"
      '';
    })
  ];
}
