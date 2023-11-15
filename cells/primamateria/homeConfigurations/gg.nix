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
          { 
            name = "hive";
            type = "custom";
            windows = ''
            windows:
              - window_name: hive
                start_directory: ~/dev/experiment-hive
              - window_name: haumea
                start_directory: ~/dev/experiment-haumea
              - window_name: paisano
                start_directory: ~/dev/experiment-paisano
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
    applications.shell
    applications.git
    applications.tmux
  ];
}
