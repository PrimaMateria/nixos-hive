Following [https://github.com/thongpv87/hive-config/blob/main/flake.nix]().
Actually it looks like this is copy of [https://github.com/Lord-Valen/configuration.nix]().

What is

- arion - docker-compose enhanced by nix
- colmena - deployment tool
- nixago - configs in nix
- nixos-generators - somehow generates different images for VM or some other platforms
- flake-compat - adapter between flake and non-flake nix systems
- aagl (as substituter) - genshiin impact launcher
- watershot (in desktop's inputs) - flameshot but for wayland
- "VCV-Rack" - music creator app
- "osu-lazer-bin" - some game for mouse agility

Hardware:
tower,
lenovo-notebook

Home Profiles:
i3
shell
git
...

NixOS Configurations:
full-tprobix
wsl-finapi
wsl-gg

User Profiles:
primamateria, mbenko

Module is from now on reserved from nix module as in nixpkgs - imports, meta &
options.
Profiles are what I have previously called modules. Different aspects of either
system or home.

```
# modules
(functions "nixosModules")
Nix module with meta, options & config.

(functions "homeModules")
I didn't find any in the repo. I assume this are supposed to be nixpkgs modules
meant to be installed via home manager, so belonging more to the user than to
the system.

# profiles
(functions "hardwareProfiles")
Hardware profiles have codenames. They inherit from inputs common and
nixos-hardware. Then as a nixpkg module they import from
nixos-hardware.nixosModules.
It's weird, because that nixos-hardware's nixosModules collide with the name of
top-level nixosModules listed as first.
They define boot kernel modules, xrandr heads.
Each codenamed instance inherits common hardware defined in the hosting
directory.

(functions "nixosProfiles")
Lot of definitions inhere. There are the bits and pieces you would construct
your system by putting it into the systemPackages. Interestingly in my existing
config I do keep this list minimal and most of the "profiles" belong to the user
space.

(functions "userProfiles")
These are not home manager things. I got used to invoking ./users.sh and wrongly
expected this will be connected. This are the user definitions on system level -
so the gropus, home directorues, default shells etc.

(functions "arionProfiles")
https://docs.hercules-ci.com/arion/
This is nix-enhanced docker compose. It could be usefull, for raspberry pi
configuration.

(functions "homeProfiles")
Finally the home manager goodies organized per aspect.

# suites
(functions "nixosSuites")
Aggregates nixosProfiles and userProfiles into a system definitions like office,
develop, desktop/laptop/server.

(functions "homeSuites")
Aggregates homeProfiles into definitions like base, laptop, lord-valen, nixos,
music, hyprland a xmonad.

So from here it looks like this:

modules -> profiles -> suites

nixos modules ->

# configurations
nixosConfigurations
diskoConfigurations
colmenaConfigurations
(installables "generators")
(installables "installers")

# pkgs
(pkgs "pkgs")

# devshells
(nixago "configs")
(devshells "devshells")
```

# What is cell?

In Lord-Valen:

- lord-valen
- repo
- sioux

Cell "lord-valen" is far the largest. "repo" looks like a demo project and
"sioux" is small one environment config. So here, most of the computers and oses
are configured in one cell which is named after the author.

In GTrunSec the cells are:

- automation
- common
- hosts
- nixos
- users

Collections of machines configs, OSes configs, and users configs.

# What would be my ideal structure?

Ideally I would take advantage of multiple cells and not cramp everything into
one single cell. The cell should stay coherent and the gravity center should not
be a type of configurations but the something with bigger semantic value.

Let's try to do some amauterous DDD.

What entities do I work with in my nixos configurations?

- x86_64: system
- wsl, bare metal: installation
- Tower PC, Lenovo Laptop: machine
- finapi, gg, tprobix: environment

About what other entities I am aware that are accompany nix even I do not use
them, so I would stay inside the frame of other people cases.

- virtual machines
- different systems - darwin, arm
- nix without nixos

# Todos

- Try to use nixago, it should magic tool for specifying configurations in nix.
  I'll keep it in the inputs.

# Diary

- I already have my dream structure prepared. I come to see the growOn funcion
  with 3 set arguments. I checked that it comes from hive -> std -> paisano. But
  at the end I saw it consume only 2 sets - the cells source & cell blocks spec,
  and the second nix cli flake output schema with harvest/collect calls. So I am
  not sure what is the third arg, and where in the chain it is processed. I
  considered asking on the matrix channel.
- There might be any number of arguments passed to growOn, labelled as layers of
  soil, all are merged together and present the flake output.
