{ lib }: {
  # Function that generates YAML files describing a tmux session that can be
  # loaded by tmuxp.
  #
  # Types of spec:
  #   - prefabs: session with prefabricated windows 
  #   - project: creates session with "code" and "run" windows in specified path
  #   ~ custom: allows to specify fully customized windows list
  #
  # Each name of the session is prefixed with F-key. Tmux has binds that
  # activate a session that name starts with the F-key. F-keys used in this
  # function start with F1 and increase based on the index of spec in the list.
  generateTmuxpConfigs = with lib; with builtins; specs:
    let
      prefabs = {
        nixos = ''
          - window_name: nixos
            start_directory: ~/dev/nixos/
        '';
        neovim-nix = ''
          - window_name: neovim
            start_directory: ~/dev/neovim-nix/
        '';
        ambients = ''
          - window_name: ambients
            start_directory: ~/Music/mp3
            panes:
              - cmus
        '';
        newsboat = ''
          - window_name: newsboat
            start_directory: ~/
            panes:
              - chatblade -i
              - newsboat
        '';
        weechat = ''
          - window_name: weechat
            start_directory: ~/
            panes:
              - weechat
        '';
      };

      generatePrefabs = foldl (accumulator: window: accumulator + (getAttr window prefabs)) "";

      fkey = spec: "F" + (toString (
        (lists.findFirstIndex (x: x.name == spec.name) null specs) + 1
      ));

      sessionName = spec: "session_name: ${fkey spec} ${spec.name}";

      contentGenerators = {
        custom = spec: ''
          ${sessionName spec}
          windows:
          ${spec.windows}
        '';
        project = spec: ''
          ${sessionName spec}
          windows:
            - window_name: code
            - window_name: run
        '';
        prefabs = spec: ''
          ${sessionName spec}
          windows:
          ${generatePrefabs spec.windows}
        '';
      };

      generateContent = spec: (getAttr spec.type contentGenerators) spec;
    in
    pipe specs [
      (map (spec: {
        name = "tmuxp/${spec.name}.yml";
        value = {
          text = generateContent spec;
        };
      }))
      listToAttrs
    ];
}
