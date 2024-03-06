{ root }:
let
  inherit (root.props) workspace;
in
{
  "${workspace 8}" = [
    { class = "^discord$"; }
    { class = "^weechat$"; }
  ];
  "${workspace 9}" = [
    { class = "^cmus$"; }
    { class = "^lyrics$"; }
  ];
}
