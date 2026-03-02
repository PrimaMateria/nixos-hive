{
  lib,
  config,
  ...
}: let
  cfg = config.primamateria.cli.vcs.repos;
in {
  options = {
    primamateria.cli.vcs.repos = {
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
      enableDefaultConfig = false;

      matchBlocks = {
        "*" = {
          forwardAgent = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          compression = false;
          addKeysToAgent = "no";
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };
        "github.com" = {
          host = "github.com";
          identityFile = "${cfg.secrets.identityFile.github}";
          hashKnownHosts = true;
        };
        "gitlab.com" = {
          host = "gitlab.com";
          identityFile = "${cfg.secrets.identityFile.gitlab}";
          hashKnownHosts = true;
        };
        "bitbucket.org" = {
          host = "bitbucket.org";
          identityFile = "${cfg.secrets.identityFile.bitbucket}";
          hashKnownHosts = true;
        };
      };
    };
  };
}
