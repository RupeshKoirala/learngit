once_each() {
  for s in "Add product review model" "Validate review rating" "Add average rating" "Document reviews"; do
    [ "$(git log --format=%s main | grep -cxF "$s")" = 1 ] || return 1
  done
}
remote_same() { [ "$(git --git-dir="$LG_DIR/remotes/origin.git" rev-parse -q --verify refs/heads/main)" = "$(git rev-parse main)" ]; }

in_repo
expect "no rebase/merge is in progress"                         no_operation
expect "you're on main"                                         on_branch main
expect "main is built on Dev's latest commit (fetched)"         is_ancestor "$(saved team)" main
expect "exactly 4 commits on top of the latest origin work"     count_is "$(saved team)..main" 4
expect "main has no merge commits at all"                       no_merges main
expect "each of your 4 commits appears exactly once"            once_each
expect "your reviews code and docs are unchanged"               git diff --quiet "$(saved original)" main -- src/reviews.js docs
expect "teammates' changes are all there"                       git diff --quiet "$(saved team)" main -- src/cart.js src/price.js .gitignore
expect "origin/main on the remote == your main (pushed)"        remote_same
expect "this repo's pull.rebase is true"                        test "$(git config --local pull.rebase)" = true
expect "the working tree is clean"                              clean_tree
finish
