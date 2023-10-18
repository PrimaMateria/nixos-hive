{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
  inherit (cell) system;
in
{
  import = [
    system.wsl
    system.essentials
    system.vnc
    system.docker
  ];

  # TODO: configure docker to use legacy iptables

  # users.users.${username} = {
  #   homeMode = "755";
  #   extraGroups = [ "docker" "wheel" "audio" "video" "networkmanager" "disk" "scanner" "lp" ];
  # };

}
