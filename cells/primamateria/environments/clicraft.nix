{
  inputs,
  cell,
}: let
  inherit (cell) cli;
in {
  imports = [
    cli.hive
    cli.shell
    cli.vcs
    cli.tmux
    cli.weechat

    {primamateria.cli.vcs.repos.groups = ["personal.tmux" "personal.extra"];}

    {
      primamateria.cli.tmux = {
        sessions = [
          {
            name = "space";
            type = "prefabs";
            windows = [
              "workbench"
              "nixos-hive"
              "neovim-nix"
              "startpages"
              "zmk"
              "blog"
            ];
          }
        ];
      };
    }
  ];
}
