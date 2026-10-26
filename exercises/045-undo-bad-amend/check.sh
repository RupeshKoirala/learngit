in_repo
B=feature/order-emails
expect "no operation is in progress"                            no_operation
expect "you're on feature/order-emails"                         on_branch $B
expect "main hasn't moved"                                      same_commit main "$(saved base)"
expect "the branch has exactly 2 commits on top of main"        count_is "main..$B" 2
expect "first commit is 'Add order confirmation email'"         msg_is "$B~1" "Add order confirmation email"
expect "…and contains exactly the original, pre-amend snapshot" tree_is_saved "$B~1" original
expect "second commit is 'Fix price rounding'"                  msg_is "$B" "Fix price rounding"
expect "…and it only touches src/price.js"                      test "$(git diff --name-only "$B~1" "$B")" = "src/price.js"
expect "the final code is exactly what you had"                 tree_is_saved "$B" amended
expect "the working tree is clean"                              clean_tree
finish
