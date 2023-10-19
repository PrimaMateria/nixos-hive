{}:
{
  import = [
    # TODO probably I can get it from flake inputs
    system.nixos-wsl
  ];

  config = {
    wsl = {
      enable = true;
      automountPath = "/mnt";
      defaultUser = "primamateria";
      startMenuLaunchers = true;
      interop.register = true;
      wslConf = {
        network = {
          generateResolvConf = false;
        };
      };
    };

    environment.etc."resolv.conf" = {
      enable = true;
      source = pkgs.writeText "resolv.conf" '' 
      nameserver 8.8.8.8
    '';
    };
  };
}
