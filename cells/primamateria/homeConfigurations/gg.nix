{ inputs, cell }:
let
  inherit (cell) bee applications;
in
{
  inherit bee;
  imports = [
    {
      home = {
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "22.05";
      };

      primamateria.applications.tmux = {
        space = [
          "nixos"
          "neovim-nix"
          "ambients"
          "newsboat"
          "weechat"
        ];
        projects = [
          "hive"
          "qmk"
        ];
      };
    }
    applications.shell
    applications.git
    applications.tmux
  ];
}
