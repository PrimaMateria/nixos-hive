{ root }:
let
  inherit (root.props) workspace;
in
[
  { command = "Enpass"; notification = false; }
  { command = "i3-msg workspace '${workspace 1}'"; notification = false; }
  { command = "firefox --kiosk --no-remote -P chatgpt --class chatgpt https://chat.openai.com"; notification = false; }
  { command = "discord"; notification = false; }
]
