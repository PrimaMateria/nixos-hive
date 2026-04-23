{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (cell) secrets;

  jiraConfig = nixpkgs.writeTextFile {
    name = "jira-cli-go-config.yml";
    text = ''
      board:
        id: 134
        name: DI Scrum
        type: scrum
      epic:
        name: customfield_11511
        link: customfield_11510
      installation: Cloud
      issue:
        fields:
          custom:
            - name: Publish Release Notes
              key: customfield_14111
              schema:
                datatype: option
            - name: Organisationen
              key: customfield_14700
              schema:
                datatype: array
                items: sd-customerorganization
            - name: Request participants
              key: customfield_13810
              schema:
                datatype: array
                items: user
            - name: Epic Link
              key: customfield_11510
              schema:
                datatype: any
            - name: Release Notes
              key: customfield_14210
              schema:
                datatype: string
            - name: Sprint
              key: customfield_10711
              schema:
                datatype: array
                items: json
            - name: Account
              key: io.tempo.jira__account
              schema:
                datatype: option2
            - name: Product owner
              key: customfield_12910
              schema:
                datatype: user
            - name: Responsible
              key: customfield_12312
              schema:
                datatype: array
                items: user
            - name: Epic Name
              key: customfield_11511
              schema:
                datatype: string
        types:
          - id: "10000"
            name: Enhancement
            handle: Enhancement
            subtask: false
          - id: "1"
            name: Bug
            handle: Bug
            subtask: false
          - id: "10900"
            name: Development sub-task
            handle: Development sub-task
            subtask: true
          - id: "10101"
            name: Task
            handle: Task
            subtask: false
          - id: "10400"
            name: Sub-task
            handle: Sub-task
            subtask: true
          - id: "10002"
            name: "Responsibility "
            handle: "Responsibility "
            subtask: false
          - id: "10800"
            name: Initiative
            handle: Initiative
            subtask: false
          - id: "6"
            name: Epic
            handle: Epic
            subtask: false
          - id: "11000"
            name: Decision
            handle: Decision
            subtask: false
          - id: "11300"
            name: Maintenance
            handle: Maintenance
            subtask: false
          - id: "11313"
            name: P0
            handle: P0
            subtask: false
      login: matus.benko@finapi.io
      project:
        key: DATAINT
        type: classic
      server: https://finapi.jira.com
    '';
  };
in {
  home.packages = [
    (nixpkgs.writeShellApplication {
      name = "jira";
      text = ''
        ${nixpkgs.jira-cli-go}/bin/jira -c ${jiraConfig} "$@"
      '';
    })
  ];

  programs.bash.initExtra = ''
    export JIRA_API_TOKEN=${secrets.wokwok.jiraApiToken}
  '';
}
