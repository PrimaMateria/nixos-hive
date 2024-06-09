# PrimaMateria's NixOS configuration

This is my main flake that declares all of my Nixified systems. It is built with
Hive and Haumea, and it contains configurations for my home station on the
desktop. I have 2 WSL instances - one running on Windows dedicated for gaming,
and the other for running on Windows at work. Currently, I am also experimenting
with a Raspberry Pi 5.

I discussed the basics of Hive in my [blog
post](https://primamateria.github.io/blog/hive/). Although it may be slightly
outdated now, if you are interested, it would be helpful to start from the
beginning rather than trying to decipher a configuration that has already
evolved.

- Windows manager: i3wm
- Terminals manager: tmux
- Secrets: git-crypt

In addition, I rely on my [neovim
flake](https://github.com/PrimaMateria/neovim-nix) and [dev
toolkit](https://github.com/PrimaMateria/dev-toolkit-nix).
