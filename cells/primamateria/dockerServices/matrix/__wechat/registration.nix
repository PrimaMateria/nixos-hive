{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;
in
  # Mirrors generateRegistration() in packages/matrix-bridge/src/matrix.ts.
  # Ghosts and aliases are keyed by sha256, hence the [a-f0-9]{64} patterns.
  # The bot user needs no namespace entry; synapse always reserves
  # sender_localpart.
  nixpkgs.writeTextFile {
    name = "matrix-wechat-registration.yaml";
    text = builtins.toJSON {
      id = "wechat";
      url = "http://matrix-wechat:17778";
      as_token = secrets.matrix.wechat.as_token;
      hs_token = secrets.matrix.wechat.hs_token;
      sender_localpart = "wechatbot";
      protocols = ["wechat"];
      rate_limited = false;
      namespaces = {
        users = [
          {
            exclusive = true;
            regex = "^@wechat_[a-f0-9]{64}:matrix\\.primamateria\\.ddns\\.net$";
          }
        ];
        aliases = [
          {
            exclusive = true;
            regex = "^#wechat_room_[a-f0-9]{64}:matrix\\.primamateria\\.ddns\\.net$";
          }
        ];
        rooms = [];
      };
    };
  }
