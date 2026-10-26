in_repo
expect "only one worktree is left (repo)"                         test "$(git worktree list --porcelain | grep -c '^worktree ')" = 1
expect "the ../hotfix folder is gone"                             test ! -e "$LG_DIR/hotfix"
expect "branch hotfix/empty-cart-crash exists"                    branch_exists hotfix/empty-cart-crash
expect "…with exactly one commit on top of the old main"          sh -c "git merge-base --is-ancestor $(saved main) hotfix/empty-cart-crash && [ \$(git rev-list --count $(saved main)..hotfix/empty-cart-crash) = 1 ]"
expect "…named 'Fix checkout crash on empty cart'"                msg_is hotfix/empty-cart-crash "Fix checkout crash on empty cart"
expect "…which only touches src/checkout.js"                      test "$(git diff --name-only hotfix/empty-cart-crash^ hotfix/empty-cart-crash)" = "src/checkout.js"
expect "main contains the hotfix"                                 is_ancestor hotfix/empty-cart-crash main
expect "main's shippingFor() guards against empty carts"          rev_file_has main src/checkout.js '(cart\.items\.length *(===?|<=?) *[01]|!cart\.items\.length|cart\.items\[0\] *===? *undefined|!cart\.items\[0\])'
expect "the BUG comment is gone on main"                          sh -c "! git grep -q BUG main -- src"
expect "repo is still on feature/reviews at the same commit"      sh -c "[ \$(git symbolic-ref --short HEAD) = feature/reviews ] && [ \$(git rev-parse HEAD) = $(saved head) ]"
expect "your staged change is untouched"                          test "$(git diff --cached | git hash-object --stdin)" = "$(cat "$LG_DIR/.lg/staged")"
expect "your unstaged change is untouched"                        test "$(git diff | git hash-object --stdin)" = "$(cat "$LG_DIR/.lg/unstaged")"
expect "your untracked src/reviews-ui.js is untouched"            test "$(git hash-object src/reviews-ui.js 2>/dev/null)" = "$(cat "$LG_DIR/.lg/untracked")"
expect "nothing was left in the stash"                            test -z "$(git stash list)"
finish
