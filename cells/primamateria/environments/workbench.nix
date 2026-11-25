# Work CLI environment: shell, repos, tmux sessions and the work TUIs.
# Shared by every work machine (wokwok on WSL, workborg on the laptop).
{
  inputs,
  cell,
}: let
  inherit (cell) cli secrets;
in {
  imports = [
    cli.hive
    cli.shell
    cli.vcs
    cli.tmux
    cli.redthread
    cli.lazyjira
    cli.jtui
    cli.depv
    cli.lazyreporting
    cli.opensearchMcp
  ];

  primamateria.cli.vcs.repos.groups = [
    "personal.tmux"
    "work.tmux"
    "personal.extra"
    "work.extra"
  ];

  # Session list lives in secrets: it names internal work repos.
  primamateria.cli.tmux.sessions = secrets.wokwok.tmuxSessions;
}
