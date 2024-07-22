{inputs}: let
  inherit (inputs) nixpkgs i3blocks-contrib;
in {
  buildContribBlock = {
    name,
    deps ? [],
    perlDeps ? [],
  }:
    nixpkgs.stdenv.mkDerivation {
      name = "i3block-${name}";
      src = "${i3blocks-contrib}";

      nativeBuildInputs = [nixpkgs.makeWrapper];

      # chang directory to the directory of the chosen block
      postUnpack = "sourceRoot=\${sourceRoot}/${name}";

      buildPhase = ''
        # create directory to hold built result
        mkdir build
        # copy the block binary into the build dir
        cp ${name} build
        # replace perl hashbangs
        sed -i 's|#!/usr/bin/perl|#!/usr/bin/env perl |' build/${name}
      '';

      installPhase = ''
        # simply copy built result into the store directory
        cp -r ./build $out

        # wrap the original binary
        # add required dependencies to the path
        # add required perl dependencies to the perl path
        wrapProgram $out/${name} \
         --prefix PATH : "${nixpkgs.lib.makeBinPath deps}" \
         --set PERL5LIB "${nixpkgs.perlPackages.makePerlPath perlDeps}"
      '';
    };
}
