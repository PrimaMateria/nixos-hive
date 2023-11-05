{ inputs, cell }:
let
  inherit (cell) nixosSuites bee;
in
{
  inherit bee;
  imports = nixosSuites.gg;
}
