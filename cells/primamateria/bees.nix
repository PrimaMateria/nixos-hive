#        ████  ████
#      ██    ██    ██
#        ██    ██  ██
#          ██████████
#        ████░░██░░░░██
#      ██░░██░░██░░░░░░▓▓
#  ▓▓▓▓██░░██░░██░░▓▓░░██
#      ██░░██░░██░░░░░░██
#        ████░░██░░░░██
#          ██████████
{
  inputs,
  cell,
}: {
  wsl = {
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs;
    home = inputs.home-manager;
    wsl = inputs.wsl;
  };
  boot = {
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs;
    home = inputs.home-manager;
  };
  rpi = {
    system = "aarch64-linux";
    pkgs = inputs.nixpkgs;
    home = inputs.home-manager;
  };
}
