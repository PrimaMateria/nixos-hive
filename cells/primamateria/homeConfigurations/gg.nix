{ inputs, cell }:
let
  inherit (cell) bee applications;
in
{
  inherit bee;
  imports = [
    applications.shell
    applications.git
    applications.tmux
    applications.newsboat
    applications.ambients
    applications.vifm

    {
      home = {
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "22.05";
      };

      primamateria.applications.tmux = {
        sessions = [
          {
            name = "space";
            type = "prefabs";
            windows = [ "nixos" "neovim-nix" "ambients" "newsboat" "weechat" ];
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
