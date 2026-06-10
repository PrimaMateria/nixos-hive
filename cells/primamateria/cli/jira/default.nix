# Jira tools
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs bitbucket-cli;
  inherit (cell) secrets;
in {
  imports = [./__jira-cli.nix];

  _module.args.secrets = secrets;

  home.packages = [
    nixpkgs.acli
    bitbucket-cli.packages.${nixpkgs.system}.bkt
  ];
}
