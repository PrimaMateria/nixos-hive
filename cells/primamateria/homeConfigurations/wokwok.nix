#
# █▄█ ▄▀▄ █▄ ▄█ ██▀
# █ █ ▀▄▀ █ ▀ █ █▄▄ wokwok
#
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
    # cli.weechat

    {
      home = {
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "22.05";
      };

      primamateria.cli.tmux = {
        sessions = [
          {
            name = "space";
            type = "prefabs";
            windows = [
              "nixos-hive"
              "neovim-nix"
              "dev-toolkit-nix"
              "startpages"
            ];
          }
          {
            name = "wokwok";
            type = "custom";
            windows = ''
              - window_name: reporting
                layout: even-horizontal
                start_directory: ~/reporting
                panes:
                  - nix develop --command ./current2
                  - nix develop
              - window_name: todo
                start_directory: ~/Documents
              - window_name: x
            '';
          }
          {
            name = "fds";
            type = "project";
            dir = "~/dev/finapi-design-system";
          }
          {
            name = "fwl";
            type = "project";
            dir = "~/dev/finapi-widget-library";
          }
          {
            name = "wf";
            type = "custom";
            windows = ''
              - window_name: feature
                start_directory: ~/dev/web-form/frontend
              - window_name: feature run
                start_directory: ~/dev/web-form/frontend
              - window_name: workbench
                start_directory: ~/dev/web-form/frontend
              - window_name: develop
                start_directory: ~/dev/wf-develop/frontend
              - window_name: develop run
                start_directory: ~/dev/wf-develop/frontend
              - window_name: backend
                start_directory: ~/dev/web-form/backend
              - window_name: ui
                start_directory: ~/dev/web-form-ui/frontend
              - window_name: ui run
                start_directory: ~/dev/web-form-ui/frontend
            '';
          }
          {
            name = "cd";
            type = "project";
            dir = "~/dev/finapi-customer-dashboard-ui";
          }
          {
            name = "fjsl";
            type = "project";
            dir = "~/dev/finapi-js-loader";
          }
          {
            name = "wfl";
            type = "project";
            dir = "~/dev/web-form-loader";
          }
          {
            name = "fhp";
            type = "project";
            dir = "~/dev/finapi-hostpages";
          }
        ];
      };

      # TODO: move JIRA token to reporting flake
      programs.bash.initExtra = ''
        export JIRA_API_TOKEN=${secrets.wokwok.jiraApiToken}
      '';
    }
  ];
}
