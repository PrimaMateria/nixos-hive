{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (cell) secrets;

  vncPasswd = nixpkgs.writeTextFile {
    name = "vnc-passwd";
    text = secrets.vncPassword;
  };

  runx = nixpkgs.writeShellApplication {
    name = "runx";
    runtimeInputs = with nixpkgs; [
      xorg.xinit
      icewm
    ];
    text = ''
      xinit icewm -- ${nixpkgs.tigervnc}/bin/Xvnc :1 PasswordFile=${vncPasswd}
    '';
  };
in {
  config = {
    services.xserver.autorun = false;
    services.xserver.windowManager.icewm.enable = true;
    services.xserver.displayManager.gdm.enable = true;

    environment.systemPackages = [runx];
  };
}
