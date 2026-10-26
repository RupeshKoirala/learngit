in_repo
B=feature/reviews
expect "no cherry-pick/rebase is in progress"                      no_operation
expect "you're on feature/reviews"                                 on_branch $B
expect "main hasn't moved"                                         same_commit main "$(saved main)"
expect "the first two branch commits are kept as they were"        is_ancestor "$(saved lost)~2" $B
expect "'Add star rating widget' is back in the branch history"    history_has_msg '^Add star rating widget$' $B
expect "'Add review moderation queue' is back in the branch history" history_has_msg '^Add review moderation queue$' $B
expect "'Fix typo in reviews header' is still in the branch history" history_has_msg '^Fix typo in reviews header$' $B
expect "the branch has exactly 5 commits on top of main"           count_is "main..$B" 5
expect "src/reviews/rating.js is back"                             test "$(git rev-parse $B:src/reviews/rating.js)" = "$(git rev-parse "$(saved lost)~1:src/reviews/rating.js")"
expect "src/reviews/moderation.js is back"                         test "$(git rev-parse $B:src/reviews/moderation.js)" = "$(git rev-parse "$(saved lost):src/reviews/moderation.js")"
expect "the header typo fix is still there"                        rev_file_has $B src/reviews/page.html "Customer reviews"
expect "the working tree is clean"                                 clean_tree
finish
