O="$LG_DIR/remotes/origin.git"
BAD=$(saved bad)
revert_commit() { git log --format=%H --grep="This reverts commit $BAD" main | tail -1; }
has_revert() { [ -n "$(revert_commit)" ]; }
fix_after_revert() { _r=$(revert_commit); [ -n "$_r" ] && is_ancestor "$_r" main && ! same_commit "$_r" main && [ -n "$(git log --format=%H "$_r..main" -- src/price.js)" ]; }
remote_main() { git --git-dir="$O" rev-parse -q --verify refs/heads/main; }
remote_contains() { git --git-dir="$O" merge-base --is-ancestor "$1" refs/heads/main 2>/dev/null; }
tests_pass() { sh ./test.sh; }

in_repo
expect "no merge/revert/rebase is in progress"                  no_operation
expect "you're on main"                                         on_branch main
expect "origin/main still contains the breaking commit (no rewrite)" remote_contains "$BAD"
expect "origin/main still contains Maya's 'Show cart total in header'" remote_contains "$(saved maya)"
expect "main has a 'git revert' of the breaking commit"         has_revert
expect "a fix-forward commit touching src/price.js comes after the revert" fix_after_revert
expect "formatPrice takes a currency again"                      rev_file_has main src/price.js 'formatPrice\(cents, *currency\)'
expect "formatPrice keeps two decimals (toFixed(2))"            rev_file_has main src/price.js 'toFixed\(2\)'
expect "your main is pushed (origin/main == main)"              test "$(remote_main)" = "$(git rev-parse main)"
expect "the working tree is clean"                              clean_tree
expect "./test.sh passes"                                       tests_pass
finish
