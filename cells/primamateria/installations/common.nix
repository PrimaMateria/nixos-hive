{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
in
{
  nixpkgs.config.allowUnfree = true;

  # Make ready for nix flakes
  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    # package = nixpkgs.unstable.nixFlakes;
  };

  time.timeZone = "Europe/Berlin";
  # networking.hostName = hostname;

  services.xserver =
    {
      enable = true;
      layout = "us,sk,de";
      xkbVariant = ",qwerty,qwerty";
      xkbOptions = "grp:lctrl_lwin_toggle";
    };

  fonts.fonts = with pkgs;
    [
      (nerdfonts.override {
        fonts = [ "CascadiaCode" ];
      })
    ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
