let
  version = "21708edc3d12c1f37285e3e9363f6541be723599";

  src = fetchFromGitHub {
    owner = "vivien";
    repo = "i3blocks-contrib";
    rev = version;
    sha256 = "0rj2q481mkbj3cawg7lsd6x0x0ii9jxnr327f8n3b2kvrdfyvzy6";
  };

  output = "$out/libexec/i3blocks";
in
{
  scriptBlock = name: required:
    stdenv.mkDerivation {
      inherit name;
      inherit version;
      inherit src;

      postUnpack = "sourceRoot=\${sourceRoot}/${name}";

      nativeBuildInputs = [ makeWrapper ];

      buildPhase = ''
        mkdir -p ${output}
      '';

      installPhase = ''
        cp ${name} ${output}
        sed -i 's|#!/usr/bin/perl|#!/usr/bin/env perl |' ${output}/${name}
        wrapProgram ${output}/${name} \
         --prefix PATH : "${makeBinPath required.bin}" \
         --set PERL5LIB "${makePerlPath required.perlDeps}"
      '';
    };

  required = args: ({
    bin = [ ];
    perlDeps = [ ];
  } // args);
}
