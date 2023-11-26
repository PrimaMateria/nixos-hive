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
            name = "nixos-hive";
            url = "git@github.com:PrimaMateria/$project.git";
          }
          {
            name = "experiment-haumea";
            url = "git@github.com:PrimaMateria/$project.git";
          }
          {
            name = "experiment-paisano";
            url = "git@github.com:PrimaMateria/$project.git";
          }
          {
            name = "startpages";
            url = "git@github.com:PrimaMateria/$project.git";
          }
          {
            name = "blog";
            url = "git@github.com:PrimaMateria/$project.git";
          }
          {
            name = "nixos";
            url = "git@github.com:PrimaMateria/$project.git";
          }
          {
            name = "neovim-nix";
            url = "git@github.com:PrimaMateria/$project.git";
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
