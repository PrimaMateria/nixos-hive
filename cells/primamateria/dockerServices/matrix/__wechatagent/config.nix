{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;
in
  nixpkgs.writeTextFile {
    name = "matrix-wechat-agent-config.yaml";
    text = builtins.toJSON {
      wechat = {
        version = "3.8.1.26";
        listen_port = 22222;
        init_timeout = "10s";
        request_timeout = "30s";
      };

      service = {
        addr = "ws://matrix-wechat:20002";
        secret = secrets.matrix.synapse.wechat_agent_key;
        ping_interval = "30s";
      };

      log.level = "info";
    };
  }
