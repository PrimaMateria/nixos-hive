{inputs}: let
  inherit (inputs) nixpkgs;
in {
  programs.bash.profileExtra = ''
    if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
  '';

  nix = {
    package = nixpkgs.nix;
    settings = {
      extra-experimental-features = ["nix-command" "flakes"];
    };
  };
}
