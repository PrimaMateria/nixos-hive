{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;
in
with lib; with builtins; {

  # Function that generates YAML files describing a tmux session that can be
  # loaded by tmuxp.
  #
  # Types of spec:
  #   - project: creates session with "code" and "run" windows in specified path
  #   ~ custom: allows to specify fully customizes windows list
  #
  # Each name of the session is prefixed with F-key. Tmux has binds that
  # activate a session that name starts with the F-key. F-keys used in this
  # function start with F2 and increase based on the index of spec in the list.
  # F1 key is reserved for special "space" session.
  generateTmuxpConfigs = specs:
    let
      fkey = spec: "F" + (toString (
        (lists.findFirstIndex (x: x.name == spec.name) null specs) + 2
      ));

      sessionName = spec: "session_name: ${fkey spec} ${spec.name}";

      contentGenerators = {
        custom = spec: ''
          ${sessionName spec}
          ${spec.windows}
        '';
        project = spec: ''
          ${sessionName spec}
          windows:
            - window_name: code
            - window_name: run
        '';
      };

      generateContent = spec: (getAttr spec.type contentGenerators) spec;
    in
    pipe specs [
      (map (spec: {
        name = "tmuxp/${spec.name}.yml";
        value = {
          text = debug.traceVal (generateContent spec);
        };
      }))
      listToAttrs
    ];
}
