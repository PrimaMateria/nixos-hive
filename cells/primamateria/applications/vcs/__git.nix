{ pkgs, ... }:
{
  home.packages = with pkgs; [
    diff-so-fancy
    lazygit
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "matus.benko";
    userEmail = "matus.benko@gmail.com";
    aliases = {
      lgb = "log -n 5 --color=always --pretty='format:%C(yellow)%h%Creset %C(green)%an%Creset %ar%C(red)%d%Creset%n%s%n' --graph";
    };
    extraConfig = {
      init.defaultBranch = "main";
      core.pager = "diff-so-fancy | less --tabs=4 -RFX";
      color.ui = true;
      "color \"diff-highlight\"" = {
        oldNormal = "red bold";
        oldHighlight = "red bold 52";
        newNormal = "green bold";
        newHighlight = "green bold 22";
      };
      "color \"diff\"" = {
        meta = 11;
        frag = "magenta bold";
        commit = "yellow bold";
        old = "red bold";
        new = "green bold";
        whitespace = "red reverse";
      };
      pull = {
        rebase = false;
      };
    };
  };
}
