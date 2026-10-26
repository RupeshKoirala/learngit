in_repo
expect "no merge is in progress"                                   no_operation
expect "you're on main"                                            on_branch main
expect "the three branches themselves are unchanged"               test "$(git rev-parse fix/price-rounding feature/gift-wrap feature/loyalty-points 2>/dev/null)" = "$(printf '%s\n' "$(saved fix)" "$(saved gift)" "$(saved loyalty)")"
expect "main's tip is a merge commit"                              is_merge main
expect "...that merged feature/gift-wrap (its second parent)"      same_commit main^2 feature/gift-wrap
expect "...on top of the fast-forwarded fix (first parent is the fix commit itself)" same_commit main^1 fix/price-rounding
expect "there is exactly one merge commit on main"                 test "$(merges_in main)" = 1
expect_not "feature/loyalty-points was NOT merged"                 is_ancestor feature/loyalty-points main
expect "ANSWER holds the fork point of loyalty-points"             answer_commit_is "$(saved forkpoint)"
expect "the working tree is clean"                                 clean_tree
finish
