{ lib, config, ... }:
let
  cfg = config.primamateria.applications.vcs.repos;
in
{
  options = {
    primamateria.applications.vcs.repos = {
      secrets = lib.mkOption {
        type = lib.types.attrs;
      };
    };
  };

  config = {
    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };

    xdg.configFile."gh/hosts.yml".text = cfg.secrets.github.hosts;

    programs.ssh = {
      enable = true;
      hashKnownHosts = true;
      matchBlocks = {
        "github.com" = {
          host = "github.com";
          identityFile = "${cfg.secrets.identityFile.github}";
        };
        "gitlab.com" = {
          host = "gitlab.com";
          identityFile = "${cfg.secrets.identityFile.gitlab}";
        };
        "bitbucket.org" = {
          host = "bitbucket.org";
          identityFile = "${cfg.secrets.identityFile.bitbucket}";
        };
      };
    };
  };
}
