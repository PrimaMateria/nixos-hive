# depv (~/dev/depv): TUI showing which release is deployed to which environment.
# The binary comes from the repo's own flake (direnv); this only provides config.
# The config itself lives in secrets (git-crypt) since it maps internal infra.
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (cell.secrets.wokwok) depv;
  yaml = nixpkgs.formats.yaml {};
in {
  # No grafana.cookie: depv reads the session from Firefox and keeps rotated
  # cookies in ~/.cache/depv/session.json.
  xdg.configFile."depv/config.yaml".source = yaml.generate "depv-config.yaml" depv.config;

  # depv rewrites favourites.yaml from the TUI, so it can't be a read-only store
  # link. Seed it once; after that it belongs to depv.
  imports = [
    ({lib, ...}: {
      home.activation.depvFavourites = lib.hm.dag.entryAfter ["writeBoundary"] ''
        fav="$HOME/.config/depv/favourites.yaml"
        if [ ! -e "$fav" ]; then
          run mkdir -p "$(dirname "$fav")"
          run cp ${yaml.generate "depv-favourites.yaml" {inherit (depv) favourites;}} "$fav"
          run chmod 644 "$fav"
        fi
      '';
    })
  ];
}
