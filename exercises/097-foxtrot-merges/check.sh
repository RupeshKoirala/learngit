FOX=$(saved foxtrot); UP=$(saved upstream); MINE=$(saved mine)
first_parent_has() { git rev-list --first-parent "$1" | grep -qx "$2"; }
remote_main() { remote_ref origin main; }
pull_safe() {
  case "$(git config --local pull.rebase 2>/dev/null)" in true|merges|interactive|i|m) return 0;; esac
  [ "$(git config --local pull.ff 2>/dev/null)" = only ]
}
remote_kept() { git --git-dir="$LG_DIR/remotes/origin.git" merge-base --is-ancestor "$UP" main; }

in_repo
expect "ANSWER names the foxtrot merge already on origin/main"          answer_commit_is "$FOX"
expect "no merge, rebase or cherry-pick is in progress"                no_operation
expect "you're on main"                                                on_branch main
expect "local main contains the latest origin/main (PR #53)"           is_ancestor "$UP" main
expect "local main's first-parent chain runs through origin/main"      first_parent_has main "$UP"
expect "exactly one commit of yours on top of origin/main"             count_is "$UP..main" 1
expect "no merge commits on top of origin/main"                        no_merges "$UP..main"
expect "your shipping copy change is there"                            rev_file_has main src/shipping.txt 'Free shipping from \$50'
expect "your commit is pushed (origin/main = main)"                    test "$(remote_main)" = "$(git rev-parse main)"
expect "origin/main was not rewritten (no force push)"                 remote_kept
expect "this repo's config makes git pull rebase (or ff-only)"         pull_safe
expect "the working tree is clean"                                     clean_tree
finish
