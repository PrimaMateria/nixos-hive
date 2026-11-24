# PrimaMateria's Hive

My main flake declaring all of my Nixified systems: a desktop tower, a home
server, a few WSL instances (gaming and work) and an older Raspberry Pi 5 setup.

- Window manager: i3wm
- Terminal multiplexer: tmux
- Secrets: git-crypt

I also rely on my [neovim flake](https://github.com/PrimaMateria/neovim-nix) and
[dev toolkit](https://github.com/PrimaMateria/dev-toolkit-nix).

## Structure

The layout was originally built with [Hive](https://github.com/divnix/hive)
(std/paisano), which I wrote about in a [blog
post](https://primamateria.github.io/blog/hive/). That ecosystem is no longer
maintained, so the flake was migrated off it: the cell/block layout stayed, but
growing and collecting is now done by a small vendored loader in `lib/` built on
[Haumea](https://github.com/nix-community/haumea). Every cell file keeps the
`{inputs, cell}` calling convention.

```
flake.nix                 inputs + hands ./cells to lib/grow.nix
lib/                      loader.nix, beeModule.nix, grow.nix
cells/primamateria/
  bees.nix                platforms: wsl, boot (x86_64), rpi (aarch64)
  nixosConfigurations/    one file per host  -> primamateria-<host>
  homeConfigurations/     one file per host  -> primamateria-<host>
  machines/ devices/      hardware
  installations/ system/  NixOS building blocks
  cli/ desktop/           home-manager building blocks
  dockerServices/         containers for the home server
  secrets/                git-crypt encrypted
```

| Host         | What                            |
| ------------ | ------------------------------- |
| `mentat`     | desktop tower, NixOS + i3       |
| `homeServer` | Beelink, headless NixOS         |
| `gg`         | WSL                             |
| `stalker`    | WSL                             |
| `wokwok`     | WSL, work                       |
| `rpi5`       | home-manager only, unmaintained |

## Setting up a new machine

### WSL only: get a NixOS distro

In an admin PowerShell, then reboot:

```powershell
wsl --install --no-distribution
```

Download `nixos.wsl` from the [NixOS-WSL
releases](https://github.com/nix-community/NixOS-WSL/releases) and import it
(an `E_FAIL` on import usually passes on a second try):

```powershell
wsl --import NixOS $env:USERPROFILE\NixOS .\Downloads\nixos.wsl --version 2
wsl -d NixOS
```

The distro starts as user `nixos`. If DNS doesn't resolve yet, put
`nameserver 8.8.8.8` into `/etc/resolv.conf` (the config does this
permanently later).

### Bootstrap

1. Clone over HTTPS, since SSH keys come from the encrypted secrets:

   ```sh
   nix-shell -p git git-crypt
   git clone https://github.com/PrimaMateria/nixos-hive ~/dev/nixos-hive
   cd ~/dev/nixos-hive
   ```

2. Copy the git-crypt key files (kept offline, not in any repo) to
   `~/dev/keychain/` (on WSL e.g. from `/mnt/c/Users/<you>/Downloads`) and
   unlock:

   ```sh
   git-crypt unlock ~/dev/keychain/hive.key
   ```

3. Build the system (the host name is not set yet, so name it explicitly):

   ```sh
   sudo nixos-rebuild switch --flake .#primamateria-<host>
   ```

4. WSL only: the default user is now `primamateria`. Restart the distro
   (`wsl -t NixOS` in PowerShell), log back in, move the bootstrap over and
   drop the `nixos` user's home:

   ```sh
   sudo mv /home/nixos/dev ~/dev && sudo chown -R primamateria ~/dev
   sudo rm -rf /home/nixos
   ```

5. Build home and switch the remote to SSH:

   ```sh
   cd ~/dev/nixos-hive
   "$(nix build --no-link --print-out-paths .#homeConfigurations.primamateria-<host>.activationPackage)/activate"
   git remote set-url origin git@github.com:PrimaMateria/nixos-hive.git
   ```

6. Clone the rest of `~/dev` and unlock the other git-crypt repos (`blog`,
   `neovim-nix`, `dev-toolkit-nix`) with their keys:

   ```sh
   hive-repos sync
   ```

   Accept the SSH host key once per git server when asked.

## Daily commands

| Command              | Does                                                   |
| -------------------- | ------------------------------------------------------ |
| `hive-reload`        | rebuild system + home for `$HOSTNAME`                  |
| `hive-reload-home`   | rebuild home only                                      |
| `hive-update`        | `nix flake update`                                     |
| `hive-repos status`  | missing repos, dirty / unpushed / stashed work         |
| `hive-repos sync`    | clone missing repos into `~/dev`, `direnv allow` them  |

Repos are listed in `cells/primamateria/cli/vcs/__repoList.nix`, grouped as
`personal`/`work` × `tmux`/`extra`. A host picks groups via
`primamateria.cli.vcs.repos.groups`. Before leaving a machine, run
`hive-repos status`: stashes and unpushed commits don't travel with a clone.

## Troubleshooting

After garbage collecting the nix store, this error occurred:

```
error: reading directory /nix/store/ynkv01653lic8ac0qkkcygws4b2ing2l-incl: No such file or directory
```

Fixed by:

```sh
sudo nix-store --verify
```

### WSL disk stays big after garbage collection

The `ext4.vhdx` doesn't shrink on its own. After `sudo nix-collect-garbage -d`:

```powershell
wsl --shutdown
diskpart
DISKPART> select vdisk file="C:\path\to\ext4.vhdx"
DISKPART> compact vdisk
```
