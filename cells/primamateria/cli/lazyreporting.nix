# lazyreporting (~/dev/lazyreporting): Watson + Jira time-tracking TUI. The
# binary comes from the repo's own flake (direnv); this only provides config.
# It also drives watson-jira, generating its config from this one on sync.
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (cell.secrets.wokwok) jira lazyreporting;
in {
  xdg.configFile."lazyreporting/config.yaml".source = (nixpkgs.formats.yaml {}).generate "lazyreporting-config.yaml" {
    jira =
      {
        server = jira.baseUrl;
        inherit (jira) email apiToken;
      }
      // lazyreporting.jira;
    inherit (lazyreporting) watson watsonJira;
  };
}
