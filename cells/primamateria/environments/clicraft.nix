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
    cli.feeds
    cli.ambients
    cli.vifm
    cli.weechat

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
