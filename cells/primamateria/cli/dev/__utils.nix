{
  lib,
  nixpkgs,
  cfg,
}:
with lib;
with builtins; {
  # Dev Project Initializer is a shell application that operates on the provided
  # list of projects. It will test if each project exists in the dev directory
  # and if not in will clone it with git.
  devProjectInitializer = let
    directories = pipe cfg.projects [
      (map (project: "$HOME/dev/${project.name}"))
      (foldl (accumulator: directory: accumulator + "\"${directory}\" ") "")
    ];

    urls = pipe cfg.projects [
      (map (project: "${project.url}"))
      (foldl (accumulator: url: accumulator + "\"${url}\" ") "")
    ];
  in
    nixpkgs.writeShellApplication
    {
      name = "devProjectInitializer";
      runtimeInputs = with nixpkgs; [git];
      text = ''
        directories=(${directories})
        git_urls=(${urls})

        for ((i = 0; i < ''${#directories[@]}; i++)); do
            directory="''${directories[i]}"
            git_url="''${git_urls[i]}"

            if [ ! -d "$directory" ]; then
                git clone "$git_url" "$directory"
            fi
        done
      '';
    };
}
