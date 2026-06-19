{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  redthread = nixpkgs.buildGoModule {
    pname = "redthread";
    version = "0-unstable-2026-06-17";
    src = nixpkgs.fetchFromGitHub {
      owner = "B33pBeeps";
      repo = "redthread";
      rev = "d8f46dd5486911bfaae1904737b32e8db8efbf33";
      hash = "sha256-nGE20xjMS4cGVIkHHULnMJKgZ5vVZtdpZGQxMPX3g3Q=";
    };
    vendorHash = "sha256-4kptp/OEahsOCnJe4gCM1jPevqhSnIB0498DfDQNjOA=";
  };
in {
  home.packages = [redthread];
}
