{ inputs, cell }:
let
  inherit (cell) bees cli;
in
{
  bee = bees.wsl;
  imports = [
    cli.shell
    cli.vcs
    cli.tmux
    cli.feeds
    cli.ambients
    cli.vifm
    cli.dev
    cli.weechat

    {
      home = {
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "22.05";
      };

      primamateria.cli.dev = {
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
          {
            name = "qmk_fjrmware";
            url = "git@github.com:PrimaMateria/qmk_firmware.git";
          }
        ];
      };

      primamateria.cli.tmux = {
        sessions = [
          {
            name = "space";
            type = "prefabs";
            windows = [
              "nixos-hive"
              "neovim-nix"
              "startpages"
              "qmk"
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
        ];
      };
    }
  ];
}
