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
    applications.feeds
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
            url = "git@github.com:PrimaMateria/nixos-hive.git";
          }
          {
            name = "experiment-haumea";
            url = "git@github.com:PrimaMateria/experiment-haumea.git";
          }
          {
            name = "experiment-paisano";
            url = "git@github.com:PrimaMateria/experiment-paisano.git";
          }
          {
            name = "startpages";
            url = "git@github.com:PrimaMateria/startpages.git";
          }
          {
            name = "blog";
            url = "git@github.com:PrimaMateria/blog.git";
          }
          {
            name = "nixos";
            url = "git@github.com:PrimaMateria/nixos.git";
          }
          {
            name = "neovim-nix";
            url = "git@github.com:PrimaMateria/neovim-nix.git";
          }
        ];
      };

      primamateria.applications.tmux = {
        sessions = [
          {
            name = "space";
            type = "prefabs";
            windows = [
              "nixos-hive"
              "neovim-nix"
              "startpages"
              "ambients"
              "newsboat"
              "weechat"
            ];
          }
          {
            name = "craft";
            type = "custom";
            windows = ''
              - window_name: blog
                start_directory: ~/dev/blog
            '';
          }
          {
            name = "qmk";
            type = "project";
            dir = "/dev/qmk_firmware/keyboards/ferris";
          }
        ];
      };
    }
  ];
}
