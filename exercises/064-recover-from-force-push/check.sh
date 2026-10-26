B=release/2.4
rgit() { git --git-dir="$LG_DIR/remotes/origin.git" "$@"; }
count_msg() { rgit log --author="$LG_LEARNER_EMAIL" --format=%s "$B" | grep -cxF "$1"; }
in_repo
expect "no cherry-pick, rebase or merge is in progress"                no_operation
expect "Dev's commits are still on origin's $B"                        rgit merge-base --is-ancestor "$(saved dev_tip)" $B
expect "'Add CA and NY sales tax rates' is on origin's $B exactly once" test "$(count_msg 'Add CA and NY sales tax rates')" = 1
expect "'Changelog: sales tax' is on origin's $B exactly once"         test "$(count_msg 'Changelog: sales tax')" = 1
expect "origin's $B has src/tax.js with the CA rate"                   sh -c "git --git-dir='$LG_DIR/remotes/origin.git' show $B:src/tax.js | grep -q 'CA: 0.0725'"
expect "origin's $B has Dev's shipping cache"                          sh -c "git --git-dir='$LG_DIR/remotes/origin.git' show $B:src/shipping.js | grep -q CACHE"
expect "your local $B matches origin's"                                test "$(git rev-parse -q --verify $B)" = "$(rgit rev-parse $B)"
expect "origin's main was not changed"                                 test "$(rgit rev-parse main)" = "$(git rev-parse origin/main)"
expect "origin rejects non-fast-forward pushes (receive.denyNonFastForwards)" test "$(rgit config --get receive.denyNonFastForwards)" = true
expect "the working tree is clean"                                     clean_tree
finish
