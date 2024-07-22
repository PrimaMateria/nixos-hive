{inputs}: let
  inherit (inputs) nixpkgs dmenu-primamateria;
  dmenu = dmenu-primamateria.packages.${nixpkgs.system}.dmenu-primamateria;
  styles = "-nb black -nf white -sb yellow -sf black -l 20 -c";
in {
  dmenu = "${dmenu}/bin/dmenu ${styles}";
  dmenuRun = "${dmenu}/bin/dmenu_run ${styles}";
}
