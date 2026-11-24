#
# █▄█ ▄▀▄ █▄ ▄█ ██▀
# █ █ ▀▄▀ █ ▀ █ █▄▄ wokwok
{
  inputs,
  cell,
}: let
  inherit (cell) bees cli secrets;
in {
  bee = bees.wsl;
  imports = [
    cli.hive
    cli.shell
    cli.vcs
    cli.tmux
    cli.feeds
    cli.ambients
    cli.vifm
    cli.redthread
    cli.lazyjira
    cli.jtui
    cli.depv
    cli.lazyreporting
    cli.opensearchMcp
    # cli.weechat

    {
      home = {
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "22.05";
      };

      primamateria.cli.vcs.repos.groups = [
        "personal.tmux"
        "work.tmux"
        "personal.extra"
        "work.extra"
      ];

      # Session list lives in secrets: it names internal work repos.
      primamateria.cli.tmux.sessions = secrets.wokwok.tmuxSessions;
    }
  ];
}
