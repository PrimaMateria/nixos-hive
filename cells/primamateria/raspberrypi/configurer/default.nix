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
