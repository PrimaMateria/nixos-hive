{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (cell) secrets;
  inherit (secrets.wokwok) jenkins;

  # https://gitlab.com/r.graff/jtui — terminal UI for Jenkins pipelines
  jtui = nixpkgs.buildGoModule rec {
    pname = "jtui";
    version = "0.7.0";
    src = nixpkgs.fetchFromGitLab {
      owner = "r.graff";
      repo = "jtui";
      rev = "v${version}";
      hash = "sha256-w9ujjFD4T4jA2z8rskONBDMEubsdKlAes9idtvdAzf4=";
    };
    vendorHash = "sha256-A2jlNyDRTWjEFu0TC+Oz6H8WQKHULjB2eiLeymr3BuY=";
    subPackages = ["."];
    doCheck = false;
    meta.mainProgram = "jtui";
  };
in {
  home.packages = [jtui];

  # jtui reads JENKINS_* from ~/.config/jtui/.env. Read-only store file, so
  # `jtui -setup` can't save; change secrets.wokwok.jenkins instead.
  xdg.configFile."jtui/.env".text = ''
    JENKINS_URL=${jenkins.url}
    JENKINS_USER=${jenkins.user}
    JENKINS_TOKEN=${jenkins.token}
  '';
}
