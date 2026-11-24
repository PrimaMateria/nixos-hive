# hive-repos: keep ~/dev in line with the repositories listed in
# __repoList.nix. Clones are done on demand (never during activation), so a
# fresh machine needs SSH keys in place before running `hive-repos sync`.
{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.primamateria.cli.vcs.repos;
  repoList = import ./__repoList.nix;

  groupNames = lib.concatMap (top: map (sub: "${top}.${sub}") (lib.attrNames repoList.${top})) (lib.attrNames repoList);

  selected = lib.foldl' (acc: group: acc // lib.attrByPath (lib.splitString "." group) {} repoList) {} cfg.groups;

  manifest = pkgs.writeText "hive-repos.tsv" (
    lib.concatStrings (lib.mapAttrsToList (name: url: "${name}\t${url}\n") selected)
  );

  hiveRepos = pkgs.writeShellApplication {
    name = "hive-repos";
    runtimeInputs = [pkgs.git pkgs.coreutils pkgs.util-linux];
    text = ''
      DEV="''${HIVE_REPOS_DIR:-$HOME/dev}"
      MANIFEST=${manifest}

      usage() {
        cat <<EOF
      Usage: hive-repos <command>

        status   show missing repos and local-only work (default)
        sync     clone missing repos into $DEV and allow their .envrc
        list     print the repos enabled for this host
      EOF
      }

      cmd_list() {
        column -t -s $'\t' "$MANIFEST"
      }

      cmd_sync() {
        mkdir -p "$DEV"
        local cloned=0 failed=0
        while IFS=$'\t' read -r name url; do
          local dir="$DEV/$name"
          [ -e "$dir" ] && continue
          echo "==> cloning $name"
          if git clone "$url" "$dir"; then
            cloned=$((cloned + 1))
            if [ -f "$dir/.envrc" ] && command -v direnv >/dev/null; then
              direnv allow "$dir"
            fi
          else
            echo "!! failed to clone $name ($url)" >&2
            failed=$((failed + 1))
          fi
        done <"$MANIFEST"
        echo "cloned: $cloned, failed: $failed"
        [ "$failed" -eq 0 ]
      }

      cmd_status() {
        local -A listed=()
        while IFS=$'\t' read -r name url; do
          listed[$name]=1
          local dir="$DEV/$name"
          if [ ! -e "$dir" ]; then
            printf '%-40s MISSING\n' "$name"
            continue
          fi
          local notes=()
          local dirty unpushed stashes worktrees
          dirty=$(git -C "$dir" status --porcelain | wc -l)
          unpushed=$(git -C "$dir" log --branches --not --remotes --oneline | wc -l)
          stashes=$(git -C "$dir" stash list | wc -l)
          worktrees=$(($(git -C "$dir" worktree list | wc -l) - 1))
          [ "$dirty" -gt 0 ] && notes+=("dirty=$dirty")
          [ "$unpushed" -gt 0 ] && notes+=("unpushed=$unpushed")
          [ "$stashes" -gt 0 ] && notes+=("stash=$stashes")
          [ "$worktrees" -gt 0 ] && notes+=("worktrees=$worktrees")
          [ "$(git -C "$dir" remote get-url origin 2>/dev/null)" != "$url" ] && notes+=("origin-differs")
          [ ''${#notes[@]} -gt 0 ] && printf '%-40s %s\n' "$name" "''${notes[*]}"
        done <"$MANIFEST"

        # git repos in ~/dev that are not part of this host's list
        for dir in "$DEV"/*/; do
          local name
          name=$(basename "$dir")
          [ -e "$dir/.git" ] || continue
          [ -n "''${listed[$name]:-}" ] && continue
          printf '%-40s UNLISTED\n' "$name"
        done
      }

      case "''${1:-status}" in
        status) cmd_status ;;
        sync) cmd_sync ;;
        list) cmd_list ;;
        -h | --help | help) usage ;;
        *)
          usage >&2
          exit 1
          ;;
      esac
    '';
  };
in {
  options.primamateria.cli.vcs.repos.groups = lib.mkOption {
    type = lib.types.listOf (lib.types.enum groupNames);
    default = [];
    example = ["personal.tmux" "personal.extra"];
    description = "Groups from __repoList.nix that hive-repos manages on this host.";
  };

  config.home.packages = [hiveRepos];
}
