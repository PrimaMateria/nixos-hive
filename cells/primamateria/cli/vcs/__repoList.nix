# Personal repos for hive-repos. The `work` groups live in
# secrets.wokwok.repos (git-crypt) and are merged in by cli/vcs/default.nix.
{
  personal = {
    tmux = {
      blog = "git@github.com:PrimaMateria/blog.git";
      dev-toolkit-nix = "git@github.com:PrimaMateria/dev-toolkit-nix.git";
      neovim-nix = "git@github.com:PrimaMateria/neovim-nix.git";
      nixos-hive = "git@github.com:PrimaMateria/nixos-hive.git";
      startpages = "git@github.com:PrimaMateria/startpages.git";
      zmk-config = "git@github.com:PrimaMateria/zmk-config.git";
    };
    extra = {
      neovim-nix-utils = "git@github.com:PrimaMateria/neovim-nix-utils.git";
      retype = "git@github.com:PrimaMateria/retype.git";
      "rsvp.nvim" = "git@github.com:PrimaMateria/rsvp.nvim.git";
    };
  };
}
