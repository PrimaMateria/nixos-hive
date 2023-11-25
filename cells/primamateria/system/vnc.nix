{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
  inherit (cell) secrets;

  # vncXstartup = nixpkgs.writeShellApplication {
  #   name = "xstartup";
  #   runtimeInputs = with nixpkgs; [ icewm ];
  #   text = "icewm";
  # };

  vncPasswd = nixpkgs.writeTextFile {
    name = "vnc-passwd";
    text = secrets.vncPassword;
  };

  # programs.bash.shellAliases = {
  #   runx = "xinit ${vncXstartup}/bin/xstartup -- $(realpath $(which Xvnc)) :1 PasswordFile=${vncPasswd}";
  # };

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
in
{
  config = {
    services.x2goserver.enable = true;
    services.xserver.autorun = false;
    services.xserver.windowManager.icewm.enable = true;
    services.xserver.displayManager.gdm.enable = true;

    environment.systemPackages = [ runx ];
  };
}
