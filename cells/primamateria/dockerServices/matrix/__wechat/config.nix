{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;
in
  nixpkgs.writeTextFile {
    name = "matrix-wechat-config.yaml";
    text = builtins.toJSON {
      homeserver = {
        address = "http://synapse:8008";
        domain = "matrix.primamateria.ddns.net";
      };

      appservice = {
        address = "http://matrix-wechat:17778";
        hostname = "0.0.0.0";
        port = 17778;
        bot_username = "wechatbot";
        registration = "/data/registration.yaml";
      };

      wechat = {
        address = "http://matrix-wechat-runtime:18743";
      };

      bridge = {
        owner = secrets.matrix.account.userId;
        command_prefix = "!wechat";
      };

      database = {
        path = "/data/matrix-wechat.db";
      };
    };
  }
