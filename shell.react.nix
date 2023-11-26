with (import <nixpkgs> { });
let
  unstable = import (fetchTarball https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz) { };
  workSecrets = import .secrets/mbenko.nix;
  workNpmRC = pkgs.writeText "work-npmrc" ''
    prefix=~/.npm-global
    init-author-name=Matus Benko
    email=${workSecrets.email}

    //registry.npmjs.org/:_authToken=${workSecrets.npmjsAuthToken}
  
    ${workSecrets.internalNpmRegistry}
  '';
  nixos-playwright = stdenv.mkDerivation {
    pname = "nixos-playwright";
    version = "0.0.1";
    src = fetchgit {
      url = "https://github.com/ludios/nixos-playwright";
      sha256 = "1yb4dx67x3qxs2842hxhhlqb0knvz6ib2fmws50aid9mzaxbl0w0";
      rev = "fdafd9d4e0e76bac9283c35a81c7c0481a8b1313";
    };
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cd $out/bin && cp $src/* .
    '';
  };

  testdebug = pkgs.writeShellApplication {
    name = "testdebug";
    runtimeInputs = [ fzf ];
    text = ''
      TARGET=$(find src -name "*.ts*"  -and -not -path '**/__test*__/**' -and -not -path '**/openapi/**'  | fzf)
      TARGETPATH="''${TARGET%/*}"
      COMPONENT=''${TARGET##*/}
      COMPONENT=''${COMPONENT%.tsx}
      COMPONENT=''${COMPONENT%.ts}
      TESTCASE="$TARGETPATH/__test__/$COMPONENT.unit.test.ts"

      npm run test:unit:debug -- --coverage --collectCoverageFrom "$TARGET" "$TESTCASE"
    '';
  };
in
mkShell {
  name = "react-shell";
  buildInputs = [
    unstable.nodejs-18_x
    unstable.mockoon

    # needed for playwright
    unstable.google-chrome-dev
    firefox-bin
    nixos-playwright

    testdebug
  ];
  shellHook = ''
    alias npm="npm --userconfig ${workNpmRC}"

    if [ ! -d "$HOME/.npm-global" ]; then 
      mkdir "$HOME/.npm-global" 
      echo "Created ~/.npm-global"
    fi
    
    export PATH="$HOME/.npm-global/bin:$PATH"

    export DISPLAY=:1
    export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true

    playwright-install () {
      #npm install -D playwright
      npx playwright install
      fix-playwright-browsers
    }
  '';
}
