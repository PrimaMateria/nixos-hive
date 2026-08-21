# PrimaMateria's NixOS configuration

This is my main flake that declares all of my Nixified systems. It is built with
a small in-repo cell loader (see `lib/`) on top of Haumea, and it contains
configurations for my home station on the desktop. I have 2 WSL instances - one
running on Windows dedicated for gaming, and the other for running on Windows at
work. Currently, I am also experimenting with a Raspberry Pi 5.

The layout was originally built with [Hive](https://github.com/divnix/hive)
(std/paisano), which I discussed in my [blog
post](https://primamateria.github.io/blog/hive/). As that ecosystem is no longer
maintained, the flake has since been migrated off it: the cell/block directory
structure is preserved, but the growing and collecting is now done by a vendored,
self-contained loader in `lib/` (`loader.nix`, `beeModule.nix`, `grow.nix`).
Each cell file keeps the same `{inputs, cell}` calling convention.

- Windows manager: i3wm
- Terminals manager: tmux
- Secrets: git-crypt

In addition, I rely on my [neovim
flake](https://github.com/PrimaMateria/neovim-nix) and [dev
toolkit](https://github.com/PrimaMateria/dev-toolkit-nix).

## Troubleshooting

After garbage collecting the nix store stuff following error occured:

```
error: reading directory /nix/store/ynkv01653lic8ac0qkkcygws4b2ing2l-incl: No such file or directory
```

Following command fixed it:

```
sudo nix-store --verify
```
