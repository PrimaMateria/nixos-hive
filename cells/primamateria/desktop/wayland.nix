# Wayland desktop, user side: niri config, Noctalia shell, foot terminal.
# System side (compositor, greeter, fonts) is system/wayland.nix.
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;

  noctalia = "noctalia msg";

  # Gruvbox Material Hard (same palette as Noctalia and foot).
  gruvbox = {
    green = "#a9b665";
    grey = "#504945";
    red = "#ea6962";
  };

  # Start from niri's own default config (well commented, all the standard
  # binds) and swap in our tools. Every pattern must still exist upstream,
  # otherwise the build fails instead of silently keeping the default.
  replacements = [
    [''spawn-at-startup "waybar"'' "// Noctalia runs as a systemd user service (desktop/wayland.nix)"]
    [
      ''{ spawn "alacritty"; }''
      (lib.concatStringsSep "\n" [
        ''{ spawn "foot"; }''
        "    Mod+Return hotkey-overlay-title=null { spawn \"foot\"; }"
      ])
    ]
    ["Open a Terminal: alacritty" "Open a Terminal: foot"]
    [''{ spawn "fuzzel"; }'' ''{ spawn-sh "${noctalia} panel-toggle launcher"; }'']
    ["Run an Application: fuzzel" "Run an Application: Noctalia launcher"]
    [''{ spawn "swaylock"; }'' ''{ spawn-sh "${noctalia} session lock"; }'']
    ["Lock the Screen: swaylock" "Lock the Screen: Noctalia"]
    [
      "        xkb {"
      (lib.concatStringsSep "\n" [
        "        xkb {"
        "            layout \"us,sk,de\""
        "            variant \",qwerty,qwerty\""
        "            options \"grp:lctrl_lwin_toggle\""
      ])
    ]

    # Look: tighter gaps, a thin gruvbox focus ring, rounded corners and no
    # client-side title bars, so every window gets the same frame.
    ["    gaps 16" "    gaps 8\n    background-color \"#000000\""]

    # Tenth workspace on Mod+0.
    ["    Mod+9 { focus-workspace 9; }" "    Mod+9 { focus-workspace 9; }\n    Mod+0 { focus-workspace 10; }"]
    ["    Mod+Ctrl+9 { move-column-to-workspace 9; }" "    Mod+Ctrl+9 { move-column-to-workspace 9; }\n    Mod+Ctrl+0 { move-column-to-workspace 10; }"]
    # Focus ring (and the disabled border) share width and inactive colour.
    ["        width 4" "        width 3"]
    [''active-color "#7fc8ff"'' ''active-color "${gruvbox.green}"'']
    [''inactive-color "#505050"'' ''inactive-color "${gruvbox.grey}"'']
    [''urgent-color "#9b0000"'' ''urgent-color "${gruvbox.red}"'']
    ["// prefer-no-csd" "prefer-no-csd"]
    [
      ''
        /-window-rule {
            geometry-corner-radius 12''
      ''
        window-rule {
            geometry-corner-radius 8''
    ]
  ];

  defaultConfig = builtins.readFile "${nixpkgs.niri.src}/resources/default-config.kdl";

  froms = map lib.head replacements;
  tos = map lib.last replacements;
  missing = lib.filter (p: !(lib.hasInfix p defaultConfig)) froms;

  # One workspace per Mod+digit: Mod+1..9 and Mod+0 focus them by position.
  workspaces = ["α" "β" "γ" "δ" "ε" "ζ" "η" "θ" "ι" "κ"];

  niriConfig = assert lib.assertMsg (missing == []) "niri default config changed, patterns not found: ${toString missing}";
    builtins.replaceStrings froms tos defaultConfig
    + "\noverview {\n    backdrop-color \"#000000\"\n}\n\n"
    + lib.concatMapStrings (name: "workspace \"${name}\"\n") workspaces;

  # Built with niri itself, so a config niri rejects fails the build.
  niriConfigFile = nixpkgs.runCommand "niri-config.kdl" {nativeBuildInputs = [nixpkgs.niri];} ''
    cp ${nixpkgs.writeText "config.kdl" niriConfig} $out
    niri validate -c $out
  '';

  # Local Noctalia plugin: Claude plan usage on the bar.
  claudeUsagePlugin = nixpkgs.runCommand "noctalia-claude-usage" {} ''
    mkdir -p $out/claude-usage
    cp ${./__noctalia-claude-usage/plugin.toml} $out/claude-usage/plugin.toml
    substitute ${./__noctalia-claude-usage/usage.luau} $out/claude-usage/usage.luau \
      --replace-fail @rateLimitsFile@ /home/primamateria/.claude/rate-limits.json
  '';
in {
  xdg.configFile."niri/config.kdl".source = niriConfigFile;

  # Defaults only: changes made in Noctalia's settings UI are stored on top of
  # these in ~/.local/state/noctalia/settings.toml.
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      shell.font_family = "Cozette";
      theme = {
        mode = "dark";
        # Community palettes are downloaded by Noctalia on first use.
        source = "community";
        community_palette = "Gruvbox Material Hard";
      };

      # Solid black desktop: no wallpaper layer, niri paints the background.
      wallpaper.enabled = false;

      bar.default = {
        margin_ends = 0;
        # Palette role "primary" = Gruvbox Material green; labels stay neutral.
        icon_color = "primary";
        start = ["launcher" "workspaces"];
        center = ["clock"];
        end = [
          "claude"
          "cpu"
          "ram"
          "temp"
          "disk"
          "tray"
          "notifications"
          "network"
          "bluetooth"
          "volume"
          "battery"
          "control-center"
          "session"
        ];
      };

      widget = {
        clock = {
          format = "{:%A %d. %B  %H:%M}";
          tooltip_format = "{:%A, %d. %B %Y, week %V}";
        };
        workspaces = {
          label_source = "name";
          max_label_chars = 8;
          # niri always keeps one empty workspace after the last one; hide
          # empty workspaces so it does not show up in the bar.
          hide_when_empty = true;
        };
        claude.type = "primamateria/claude-usage:usage";
        cpu = {
          type = "sysmon";
          stat = "cpu_usage";
          visualization = "graph";
        };
        ram = {
          type = "sysmon";
          stat = "ram_used";
        };
        temp = {
          type = "sysmon";
          stat = "cpu_temp";
        };
        disk = {
          type = "sysmon";
          stat = "disk_used_pct";
          path = "/";
        };
      };

      plugins = {
        enabled = ["primamateria/claude-usage"];
        source = [
          {
            name = "hive";
            kind = "path";
            location = "${claudeUsagePlugin}";
            enabled = true;
          }
        ];
      };
    };
  };

  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        # Bitmap font with Nerd Font icons (installed in system/wayland.nix).
        font = "Cozette:pixelsize=13";
        pad = "6x6";
      };
      # Gruvbox Material Hard, the terminal colours of Noctalia's palette.
      # (foot >= 1.24 calls the section colors-dark; plain [colors] is rejected.)
      colors-dark = {
        background = "1d2021";
        foreground = "d4be98";
        selection-background = "282828";
        selection-foreground = "d4be98";
        cursor = "1d2021 d4be98";
        regular0 = "7c6f64";
        regular1 = "ea6962";
        regular2 = "a9b665";
        regular3 = "d8a657";
        regular4 = "7daea3";
        regular5 = "d3869b";
        regular6 = "89b482";
        regular7 = "d4be98";
        bright0 = "928374";
        bright1 = "ea6962";
        bright2 = "a9b665";
        bright3 = "d8a657";
        bright4 = "7daea3";
        bright5 = "d3869b";
        bright6 = "89b482";
        bright7 = "ddc7a1";
      };
    };
  };
}
