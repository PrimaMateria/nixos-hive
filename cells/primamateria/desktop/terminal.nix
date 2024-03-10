{}:
{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";

      window.dimensions.columns = 150;
      window.dimensions.lines = 50;

      window.padding.x = 5;
      window.padding.y = 5;

      font.normal.family = "CaskaydiaCove Nerd Font Mono";
      font.size = 8.0;

      colors = {
        primary = {
          background = "0x1c1c1c";
          foreground = "0xebdbb2";
        };
        normal = {
          black = "0x282828";
          red = "0xcc241d";
          green = "0x98971a";
          yellow = "0xd79921";
          blue = "0x458588";
          magenta = "0xb16286";
          cyan = "0x689d6a";
          white = "0xffffff";
        };
        bright = {
          black = "0x928374";
          red = "0xfb4934";
          green = "0xb8bb26";
          yellow = "0xfabd2f";
          blue = "0x83a598";
          magenta = "0xd3869b";
          cyan = "0x8ec07c";
          white = "0xffffff";
        };
      };
    };
  };
}
