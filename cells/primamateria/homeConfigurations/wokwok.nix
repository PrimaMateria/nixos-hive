{ inputs, cell }:
let
  inherit (cell) bee applications secrets;
in
{
  inherit bee;
  imports = [
    applications.shell
    applications.vcs
    applications.tmux
    applications.feeds
    applications.ambients
    applications.vifm
    applications.dev
    applications.weechat

    {
      home = {
        username = "primamateria";
        homeDirectory = "/home/primamateria";
        stateVersion = "22.05";
      };

      primamateria.applications.dev = {
        projects = [
          {
            name = "nixos-hive";
            url = "git@github.com:PrimaMateria/nixos-hive.git";
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
            name = "finapi-build-library";
            url = "git@bitbucket.org:teaminvest/build-library.git";
          }
          {
            name = "finapi-cms";
            url = "git@bitbucket.org:teaminvest/cms.git";
          }
          {
            name = "finapi-design-system";
            url = "git@bitbucket.org:teaminvest/design-system.git";
          }
          {
            name = "finapi-hostpages";
            url = "git@bitbucket.org:teaminvest/hostpages.git";
          }
          {
            name = "finapi-process-ctrl";
            url = "git@bitbucket.org:teaminvest/process-ctrl.git";
          }
          {
            name = "finapi-widget-library";
            url = "git@bitbucket.org:teaminvest/widget-library.git";
          }
          {
            name = "finapi-js-loader";
            url = "git@bitbucket.org:teaminvest/js-loader.git";
          }
          {
            name = "finapi-js-static-resources";
            url = "git@bitbucket.org:teaminvest/js-static-resources.git";
          }
          {
            name = "web-form";
            url = "git@bitbucket.org:teaminvest/web-form.git";
          }
          {
            name = "web-form-loader";
            url = "git@bitbucket.org:teaminvest/web-form-loader.git";
          }
        ];
      };

      primamateria.applications.tmux = {
        sessions = [
          {
            name = "space";
            type = "prefabs";
            windows = [
              "nixos-hive"
              "nixos"
              "neovim-nix"
              "startpages"
              "ambients"
              "newsboat"
              "weechat"
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
            type = "project";
            dir = "~/dev/web-form/frontend";
          }
          {
            name = "cuda";
            type = "project";
            dir = "~/dev/nextjs-dashboard";
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

      # TODO: either to project flakes or to dev application
      programs.bash.shellAliases = {
        shell-react = "nix-shell ~/dev/nixos/shell.react.nix";
      };

      # TODO: move JIRA token to reporting flake
      programs.bash.initExtra = ''
        export JIRA_API_TOKEN=${secrets.wokwok.jiraApiToken}
      '';
    }
  ];
}
