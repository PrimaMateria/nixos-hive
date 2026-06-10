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
      settings = {
        "*" = {
          ForwardAgent = false;
          ServerAliveInterval = 0;
          ServerAliveCountMax = 3;
          Compression = false;
          AddKeysToAgent = "no";
          HashKnownHosts = lib.mkForce false;
          UserKnownHostsFile = "~/.ssh/known_hosts";
          ControlMaster = "no";
          ControlPath = "~/.ssh/master-%r@%n:%p";
          ControlPersist = "no";
        };
        "github.com" = {
          HostName = "github.com";
          IdentityFile = "${cfg.secrets.identityFile.github}";
          HashKnownHosts = true;
        };
        "gitlab.com" = {
          HostName = "gitlab.com";
          IdentityFile = "${cfg.secrets.identityFile.gitlab}";
          HashKnownHosts = true;
        };
        "bitbucket.org" = {
          HostName = "bitbucket.org";
          IdentityFile = "${cfg.secrets.identityFile.bitbucket}";
          HashKnownHosts = true;
        };
        "finapi.ghe.com" = {
          HostName = "finapi.ghe.com";
          IdentityFile = "${cfg.secrets.identityFile.ghe}";
          HashKnownHosts = true;
        };
      };
    };
  };
}
