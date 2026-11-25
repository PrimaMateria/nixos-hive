# Work-only desktop apps, kept off the personal machines.
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  home.packages = with nixpkgs; [
    slack
    # nixpkgs' `teams` is macOS only; this is the community Linux client.
    teams-for-linux
  ];
}
