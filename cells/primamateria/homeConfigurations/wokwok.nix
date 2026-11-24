#
# █▄█ ▄▀▄ █▄ ▄█ ██▀
# █ █ ▀▄▀ █ ▀ █ █▄▄ wokwok
{
  inputs,
  cell,
}: let
  inherit (cell) bees cli;
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

      primamateria.cli.tmux = {
        sessions = [
          # F1
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
          # F2
          {
            name = "space-station";
            type = "custom";
            windows = ''
              - window_name: reporting
                start_directory: ~/dev/lazyreporting
                panes:
                  - lr
              - window_name: todo
                start_directory: ~/Documents
                panes:
                  - redthread
              - window_name: depv
                start_directory: ~/dev/depv/
                panes:
                  - depv
              - window_name: lazyjira
                panes:
                  - lazyjira
              - window_name: jtui
                panes:
                  - jtui
              - window_name: x
            '';
          }
          # F3
          {
            name = "planet-design-system";
            type = "custom";
            windows = ''
              - window_name: finapi-design-system
                start_directory: ~/dev/finapi-design-system/
              - window_name: web-form-design-system
                start_directory: ~/dev/web-form-design-system/
            '';
          }
          # F4
          {
            name = "planet-widget-library";
            type = "custom";
            windows = ''
              - window_name: code
                start_directory: ~/dev/finapi-widget-library/
              - window_name: run
                start_directory: ~/dev/finapi-widget-library/
                panes:
                  - echo "lib"
                  - echo "widget"
            '';
          }
          # F5
          {
            name = "planet-web-form";
            type = "custom";
            windows = ''
              - window_name: code 2_1
                start_directory: ~/dev/web-form-ui-2_1
              - window_name: run 2_1
                start_directory: ~/dev/web-form-ui-2_1
              - window_name: code 2_0
                start_directory: ~/dev/web-form-ui
              - window_name: run 2_0
                start_directory: ~/dev/web-form-ui
              - window_name: mockoon
                start_directory: ~/dev/web-form-ui-2_1
            '';
          }
          # F6
          {
            name = "planet-customer-dashboard";
            type = "project";
            dir = "~/dev/finapi-customer-dashboard-ui";
          }
          # F7
          {
            name = "planet-order-process";
            type = "project";
            dir = "~/dev/finapi-orderprocess-ui/";
          }
          # F8
          {
            name = "void";
            type = "custom";
            windows = ''
              - window_name: void
                start_directory: /tmp
            '';
          }
          # F9
          {
            name = "moons";
            type = "custom";
            windows = ''
              - window_name: hostpages
                start_directory: ~/dev/finapi-hostpages/
              - window_name: webform-loader
                start_directory: ~/dev/web-form-loader/
              - window_name: js-loader
                start_directory: ~/dev/finapi-js-loader/
              - window_name: static-resources
                start_directory: ~/dev/finapi-js-static-resources/
              - window_name: web-utils
                start_directory: ~/dev/finapi-web-utils/
            '';
          }
        ];
      };
    }
  ];
}
