{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (cell) secrets;

  runx = nixpkgs.writeShellApplication {
    name = "runx";
    runtimeInputs = with nixpkgs; [
      xinit
      icewm
    ];
    text = ''
      xinit icewm -- ${nixpkgs.tigervnc}/bin/Xvnc :1 PasswordFile=${secrets.vncPasswordFile}
    '';
  };
in {
  config = {
    services.xserver.autorun = false;
    services.xserver.windowManager.icewm.enable = true;
    services.displayManager.gdm.enable = true;

    environment.systemPackages = [runx];
  };
}
