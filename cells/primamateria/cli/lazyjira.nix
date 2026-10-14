{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (cell) secrets;
  inherit (secrets.wokwok) jira;
  lazyjira = inputs.lazyjira.packages.${nixpkgs.stdenv.hostPlatform.system}.default;

  # gruvbox dark palette
  gruvbox = {
    white = "#ebdbb2";
    gray = "#928374";
    green = "#b8bb26";
    blue = "#83a598";
    cyan = "#8ec07c";
    red = "#fb4934";
    yellow = "#fabd2f";
    magenta = "#d3869b";
    orange = "#fe8019";
    highlight = "#504945";
  };
in {
  # lazyjira reads the token only from auth.json or env, never from config.yml
  home.packages = [
    (nixpkgs.writeShellApplication {
      name = "lazyjira";
      text = ''
        export JIRA_API_TOKEN=${nixpkgs.lib.escapeShellArg jira.apiToken}
        exec ${nixpkgs.lib.getExe lazyjira} "$@"
      '';
    })
  ];

  xdg.configFile."lazyjira/config.yml".source = (nixpkgs.formats.yaml {}).generate "lazyjira-config.yml" {
    jira = {
      host = jira.baseUrl;
      inherit (jira) email;
      serverType = "cloud";
    };
    gui = {
      theme = "default";
      themeColors = gruvbox;
      # lazyjira clamps the side panel to half the terminal width; ask for the max
      sidePanelWidth = 1000;
      # key is still shown in the detail panel; give the room to titles
      issueListFields = ["status" "summary"];
    };
    issueTabs = [
      {
        name = "Frontend board";
        jql = "filter = 23662 AND sprint in openSprints() ORDER BY Rank ASC";
      }
      {
        name = "Mine";
        jql = "filter = 23662 AND sprint in openSprints() AND assignee = currentUser() ORDER BY Rank ASC";
      }
    ];
  };
}
