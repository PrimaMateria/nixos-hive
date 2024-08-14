{inputs}: let
  inherit (inputs) nixpkgs;
  version = "6e959f3073d9a3d6a4bc65215f186d3b519dec84";
in
  nixpkgs.stdenv.mkDerivation rec {
    name = "matrix-synapse-shared-secret-auth-${version}";
    src = nixpkgs.fetchFromGitHub {
      owner = "devture";
      repo = "matrix-synapse-shared-secret-auth";
      rev = version;
      sha256 = "sha256-hj7aq9GoyRZQXgpl4GZqDJddV08Mc+lBC6ZH9oDH9R0=";
    };
    installPhase = ''
      mkdir -p $out
      cp shared_secret_authenticator.py $out/shared_secret_authenticator.py
    '';
  }
