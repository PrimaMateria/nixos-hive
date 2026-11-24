# Version Control System
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (cell) secrets;
in {
  imports = [
    ./__git.nix
    ./__secrets.nix
    ./__repos.nix
    (import ./__hiveRepos.nix {workRepos = secrets.wokwok.repos;})
  ];

  primamateria.cli.vcs.repos = {
    secrets = {
      inherit (secrets) github;
      identityFile = {
        inherit (secrets.identityFile) github gitlab bitbucket ghe;
      };
    };
  };
}
