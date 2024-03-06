{
  # xprop
  # instance = WM_CLASS[0]
  # class = WM_CLASS[1]
  # title = _NET_WM_NAME, WM_NAME
  # watch xdotool getwindowfocus getwindowgeometry

  hideEdgeBorders = "none";
  commands = [
    # Enpass
    {
      criteria = { class = "Enpass"; title = "^Enpass$"; };
      command = "floating enable";
    }
    {
      criteria = { class = "Enpass"; title = "^Enpass$"; };
      command = "resize set 800 520";
    }
    {
      criteria = { class = "Enpass"; title = "^Enpass$"; };
      command = "move absolute position 1678 918";
    }
    {
      criteria = { class = "Enpass"; title = "^Enpass$"; };
      command = "move scratchpad";
    }

    # i3blocks-gcalcli
    {
      criteria = { class = "XTerm"; title = "i3blocks-gcalcli"; };
      command = "floating enable";
    }
    {
      criteria = { class = "XTerm"; title = "i3blocks-gcalcli"; };
      command = "border none";
    }
    {
      criteria = { class = "XTerm"; title = "i3blocks-gcalcli"; };
      command = "move position center";
    }

    # ChatGPT
    {
      criteria = { class = "chatgpt"; };
      command = "floating enable";
    }
    {
      criteria = { class = "chatgpt"; };
      command = "move absolute position 565 180";
    }
    {
      criteria = { class = "chatgpt"; };
      command = "resize set 1395 1110";
    }
    {
      criteria = { class = "chatgpt"; };
      command = "move scratchpad";
    }
    {
      criteria = { class = "chatgpt"; };
      command = "fullscreen disable";
    }
  ];
}
