rgit() { git --git-dir="$LG_DIR/remotes/origin.git" "$@"; }
no_ref() { ! git show-ref --verify -q "$1"; }
in_repo
expect "stale origin/feature/gift-cards was pruned"            no_ref refs/remotes/origin/feature/gift-cards
expect "stale origin/fix/old-tax was pruned"                   no_ref refs/remotes/origin/fix/old-tax
expect "local feature/gift-cards was deleted"                  no_ref refs/heads/feature/gift-cards
expect "spike/old-checkout is deleted on the server"           test -z "$(remote_ref origin spike/old-checkout)"
expect "... and origin/spike/old-checkout is gone locally too" no_ref refs/remotes/origin/spike/old-checkout
expect "the server has main at the old master commit"          test "$(remote_ref origin main)" = "$(saved master_tip)"
expect "the server has no master branch any more"              test -z "$(remote_ref origin master)"
expect "the server's default branch (HEAD) is main"            test "$(rgit symbolic-ref HEAD 2>/dev/null)" = refs/heads/main
expect "locally, master was renamed to main"                   sh -c 'git show-ref --verify -q refs/heads/main && ! git show-ref --verify -q refs/heads/master'
expect "local main tracks origin/main"                         test "$(upstream_of main)" = origin/main
expect "no origin/master left in your clone"                   no_ref refs/remotes/origin/master
expect "origin/HEAD points at origin/main"                     test "$(git symbolic-ref -q refs/remotes/origin/HEAD)" = refs/remotes/origin/main
expect "the working tree is clean"                             clean_tree
finish
