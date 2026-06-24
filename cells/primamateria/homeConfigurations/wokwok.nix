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
    cli.jira
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
              "zmk"
            ];
          }
          {
            name = "wokwok";
            type = "custom";
            windows = ''
              - window_name: reporting
                start_directory: ~/dev/lazyreporting
                panes:
                  - lr
              - window_name: todo
                start_directory: ~/Documents
              - window_name: x
              - window_name: reporting dev
                start_directory: ~/dev/lazyreporting
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
              - window_name: 2.1 code
                start_directory: ~/dev/web-form-ui-2_1
              - window_name: 2.1 run
                start_directory: ~/dev/web-form-ui-2_1
              - window_name: 2.1-w code
                start_directory: ~/dev/web-form-ui-2_1-worktree
              - window_name: 2.1-w run
                start_directory: ~/dev/web-form-ui-2_1-worktree
              - window_name: 2.0 code
                start_directory: ~/dev/web-form-ui
              - window_name: 2.0 run
                start_directory: ~/dev/web-form-ui
              - window_name: mockoon
                start_directory: ~/dev/web-form-ui-2_1
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
    }
  ];
}
