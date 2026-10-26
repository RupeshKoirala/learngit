rgit() { git --git-dir="$LG_DIR/remotes/origin.git" "$@"; }
r_msg_is() { [ "$(rgit log -1 --format=%s "$1" 2>/dev/null)" = "$2" ]; }
in_repo
expect "no rebase or merge is in progress"                         no_operation
expect "origin/main still contains Dev's fix (nothing was force-pushed away)" rgit merge-base --is-ancestor "$(saved dev_fix)" main
expect "origin/main tip is 'Show banner on cart page'"             r_msg_is main "Show banner on cart page"
expect "below it: 'Add free-shipping banner'"                      r_msg_is main~1 "Add free-shipping banner"
expect "below that: Dev's fix (your commits were replayed on top)" test "$(rgit rev-parse main~2)" = "$(saved dev_fix)"
expect "origin/main has no merge commits"                          test "$(rgit rev-list --merges --count main)" = 0
expect "your local main matches origin's main"                     test "$(git rev-parse main)" = "$(rgit rev-parse main)"
expect "the working tree is clean"                                 clean_tree
finish
