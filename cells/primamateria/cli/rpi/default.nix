{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
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

  home.packages = [
    (nixpkgs.writeShellApplication {
      name = "hive-rpi5-sync";
      runtimeInputs = [nixpkgs.rsync];
      text = ''
        rsync -a "$HOME/dev/nixos-hive" "rpi5:/home/primamateria/dev/"
      '';
    })
  ];
}
