{
  inputs,
  cell,
}: let
  inherit (cell) secrets;
in {
  programs.iamb = {
    enable = true;
    settings = {
      profiles.default = {
        user_id = secrets.matrix.account.userId;
      };
      settings.default_profile = "default";
    };
  };
}
