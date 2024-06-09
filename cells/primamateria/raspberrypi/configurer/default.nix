# Since rpi5 is running pure Nix and not everything is possible to declare in
# NixOS, this configuration script tries to stay as close to a declarative
# approach as possible. The script should be written in a way that it can be run
# repeatedly in any state.
{
  inputs,
  cell,
  super,
}: let
  inherit (inputs) nixpkgs;
in {
  home.packages = [
    (nixpkgs.writeShellApplication
      {
        name = "rpi5-configure";
        text = ''
          echo
          echo -e '\033[1;33m██████╗ ██████╗ ██╗ \033[0;37m███████╗'
          echo -e '\033[1;33m██╔══██╗██╔══██╗██║ \033[0;37m██╔════╝ \033[1;32m  ⋱⋱ ⋰⋰'
          echo -e '\033[1;33m██████╔╝██████╔╝██║ \033[0;37m███████╗ \033[1;31m  ◖ ● ◗'
          echo -e '\033[1;33m██╔══██╗██╔═══╝ ██║ \033[0;37m╚════██║ \033[1;31m ◖ ● ● ◗'
          echo -e '\033[1;33m██║  ██║██║     ██║ \033[0;37m███████║ \033[1;31m  ◖ ● ◗ '
          echo -e '\033[1;33m╚═╝  ╚═╝╚═╝     ╚═╝ \033[0;37m╚══════╝ \033[1;31m    •'
          echo -en "\033[0m"

          ${super.boot}
          ${super.docker}
        '';
      })
  ];
}
