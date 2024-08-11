{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
  inherit (inputs) nixpkgs;
in
  nixpkgs.writeTextFile {
    name = "matrix-wechat-registration.yaml";
    text = builtins.toJSON {
      id = "wechat";
      url = "http://matrix-wechat:17778";
      as_token = secrets.matrix.synapse.wechat_as_token;
      hs_token = secrets.matrix.synapse.wechat_hs_token;
      sender_localpart = "tcMC6UH6RL0XgI6u5ONiCZL1w0C2KQY5";
      rate_limited = false;
      namespaces = {
        users = [
          {
            regex = "^@wechatbot:primamateria\\.ddns\\.net$";
            exclusive = true;
          }
          {
            regex = "^@_wechat_.*:primamateria\\.ddns\\.net$";
            exclusive = true;
          }
        ];
      };
      "de.sorunome.msc2409.push_ephemeral" = true;
      push_ephemeral = true;
    };
  }
