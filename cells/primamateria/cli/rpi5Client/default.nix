# This configuration is for the client that is connecting and working with RPi5
# via SSH.
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (cell) secrets;
in {
  home.packages = [
    # Sync the client's hive to the Raspberry Pi.
    (nixpkgs.writeShellApplication {
      name = "hive-rpi5-sync";
      runtimeInputs = [nixpkgs.rsync];
      text = ''
        rsync -a "$HOME/dev/nixos-hive" "rpi5:/home/primamateria/dev/"
      '';
    })

    # Watch all files in the current folder (assuming hive root) and execute
    # sync if any changes occur.
    (nixpkgs.writeShellApplication {
      name = "hive-rpi5-sync-watch";
      runtimeInputs = [nixpkgs.entr];
      text = ''
        find ./ | entr hive-rpi5-sync
      '';
    })
  ];
}
