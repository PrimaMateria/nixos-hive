{ lib }: with lib; with builtins; {
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
  generateTmuxpConfigs = sessions:
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

      fkey = session: "F" + (toString (
        (lists.findFirstIndex (x: x.name == session.name) null sessions) + 1
      ));

      sessionName = session: "session_name: ${fkey session} ${session.name}";

      contentGenerators = {
        custom = session: ''
          ${sessionName session}
          windows:
          ${session.windows}
        '';
        project = session: ''
          ${sessionName session}
          windows:
            - window_name: code
            - window_name: run
        '';
        prefabs = session: ''
          ${sessionName session}
          windows:
          ${generatePrefabs session.windows}
        '';
      };

      generateContent = session: (getAttr session.type contentGenerators) session;
    in
    pipe sessions [
      (map (session: {
        name = "tmuxp/${session.name}.yml";
        value = {
          text = generateContent session;
        };
      }))
      listToAttrs
    ];

  # Picks names from the provided sessions and joins them space separated into
  # one string.
  generateTmuxpLoadArgs = foldl (acc: session: acc + " ${session.name}") "";
}
