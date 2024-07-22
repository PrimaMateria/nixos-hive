{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  config = {
    wsl = {
      enable = true;
      defaultUser = "primamateria";
      startMenuLaunchers = true;
      nativeSystemd = true;

      wslConf = {
        network = {
          generateResolvConf = false;
        };

        interop = {
          enabled = true;
          appendWindowsPath = true;
        };
      };

      interop = {
        register = true;
        includePath = true;
      };
    };

    environment.etc."resolv.conf" = {
      enable = true;
      source = nixpkgs.writeText "resolv.conf" ''
        nameserver 8.8.8.8
      '';
    };

    environment.systemPackages = [
      (nixpkgs.writeShellApplication {
        name = "firefox";
        text = ''
          /mnt/c/Program\ Files/Mozilla\ Firefox/firefox.exe "$@"
        '';
      })
    ];
  };
}
