{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
in
{
  time.timeZone = "Europe/Berlin";

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
  };
  services.xserver = {
    enable = true;
    xkb = { 
      layout = "us,sk,de";
      variant = ",qwerty,qwerty";
      options = "grp:lctrl_lwin_toggle";
    };
  };

  fonts.packages = with nixpkgs;
    [
      (nerdfonts.override {
        fonts = [ "CascadiaCode" ];
      })
    ];

  users.users.primamateria = {
    isNormalUser = true;
    homeMode = "755";
    extraGroups = [ "wheel" "audio" "video" "networkmanager" "disk" "scanner" "lp" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
