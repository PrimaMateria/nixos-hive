{cell}: let
  inherit (cell) secrets;
in {
  programs.ssh = {
    enable = true;
    hashKnownHosts = true;
    matchBlocks = {
      "rip5" = {
        host = "192.168.178.61";
        identityFile = "${secrets.identityFile.rpi5}";
      };
    };
  };
}
