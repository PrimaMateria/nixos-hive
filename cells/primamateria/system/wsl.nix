{}:
{
  import = [
    # probably I can get it from flake inputs
    system.nixos-wsl
  ];

  config = {
    wsl = {
      enable = true;
      automountPath = "/mnt";
      # defaultUser = username;
      startMenuLaunchers = true;
      interop.register = true;
      wslConf = {
        network = {
          # inherit hostname;
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
