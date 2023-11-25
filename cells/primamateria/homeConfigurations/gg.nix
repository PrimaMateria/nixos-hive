{ inputs, cell }:
let
  inherit (cell) bee applications;
in
{
  inherit bee;
  imports = [
    applications.shell
    applications.vcs
    applications.tmux
    applications.newsboat
    applications.ambients
    applications.vifm
    applications.dev
    applications.weechat

    {
      home = {
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "22.05";
      };

      primamateria.applications.dev = {
        projects = [
          {
            name = "experiment-hive";
            url = "https://github.com/PrimaMateria/experiment-hive";
          }
          {
            name = "experiment-haumea";
            url = "https://github.com/PrimaMateria/experiment-haumea";
          }
          {
            name = "experiment-paisano";
            url = "https://github.com/PrimaMateria/experiment-paisano";
          }
          {
            name = "startpages";
            url = "https://github.com/PrimaMateria/startpages";
          }
          {
            name = "blog";
            url = "https://github.com/PrimaMateria/blog";
          }
          {
            name = "nixos";
            url = "https://github.com/PrimaMateria/nixos";
          }
          {
            name = "neovim-nix";
            url = "https://github.com/PrimaMateria/neovim-nix";
          }
        ];
      };

      primamateria.applications.tmux = {
        sessions = [
          {
            name = "space";
            type = "prefabs";
            windows = [ "neovim-nix" "ambients" "newsboat" "weechat" ];
          }
          {
            name = "hive";
            type = "custom";
            windows = ''
              - window_name: hive
                start_directory: ~/dev/experiment-hive
              - window_name: haumea
                start_directory: ~/dev/experiment-haumea
              - window_name: paisano
                start_directory: ~/dev/experiment-paisano
              - window_name: nixos
                start_directory: ~/dev/nixos
            '';
          }
          {
            name = "qmk";
            type = "project";
            dir = "/mnt/c/Users/matus/qmk_firmware/keyboards/ferris";
          }
        ];
      };
    }
  ];
}
