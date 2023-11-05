{ inputs, cell }:
let 
  inherit (inputs) nixpkgs;
in
{
  config = {
    wsl = {
      enable = true;
      defaultUser = "primamateria";
      startMenuLaunchers = true;
      interop.register = true;
      wslConf = {
        automount.root = "/mnt";
        network = {
          generateResolvConf = false;
        };
      };
    };

    environment.etc."resolv.conf" = {
      enable = true;
      source = nixpkgs.writeText "resolv.conf" '' 
      nameserver 8.8.8.8
    '';
    };
  };
}
