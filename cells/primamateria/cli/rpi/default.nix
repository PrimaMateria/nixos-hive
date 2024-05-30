{cell}: let
  inherit (cell) secrets;
in {
  programs.ssh = {
    enable = true;
    hashKnownHosts = true;
    matchBlocks = {
      "rip5" = {
        host = "rpi5";
        identityFile = "${secrets.identityFile.rpi5}";
      };
    };
  };
}
