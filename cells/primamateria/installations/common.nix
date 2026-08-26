{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  # `grow.nix` swaps `inputs.nixpkgs` for an instantiated pkgs set, so the raw
  # flake - the one `nixpkgs.follows` points at - is reached under its own name.
  nixpkgsFlake = inputs.nixpkgs-unstable;
in {
  time.timeZone = "Europe/Berlin";

  nix = {
    extraOptions = "experimental-features = nix-command flakes";

    # `nix-shell -p`, `nix-build` and `<nixpkgs>` resolve through NIX_PATH, which
    # by default points at root's nix-channel profile - state that no flake ever
    # touches, so it rots at whatever `nix-channel --update` last fetched. Point
    # it at this flake's locked nixpkgs instead.
    nixPath = ["nixpkgs=/etc/nix/inputs/nixpkgs"];

    # Same story for the flake CLI: make `nix shell nixpkgs#cargo` and friends
    # resolve to the locked input rather than the online registry's channel.
    registry.nixpkgs.flake = nixpkgsFlake;
  };

  # Indirection so NIX_PATH stays a stable string across rebuilds instead of
  # baking a store hash into every shell's environment.
  environment.etc."nix/inputs/nixpkgs".source = nixpkgsFlake.outPath;

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us,sk,de";
      variant = ",qwerty,qwerty";
      options = "grp:lctrl_lwin_toggle";
    };
  };

  users.users.primamateria = {
    isNormalUser = true;
    homeMode = "755";
    extraGroups = ["wheel" "audio" "video" "networkmanager" "disk" "scanner" "lp"];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
