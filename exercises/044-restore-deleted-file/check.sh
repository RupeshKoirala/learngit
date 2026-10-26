in_repo
D=$(saved deleter)
expect "ANSWER holds the hash of the commit that deleted src/coupons.js"  answer_commit_is "$D"
expect "no operation is in progress"                                       no_operation
expect "you're on main"                                                    on_branch main
expect "existing history wasn't rewritten"                                 is_ancestor "$(saved main)" main
expect "exactly 1 new commit on main"                                      count_is "$(saved main)..main" 1
expect "src/coupons.js is committed again"                                 in_commit main src/coupons.js
expect "…with exactly its content from right before the deletion"          test "$(git rev-parse main:src/coupons.js)" = "$(git rev-parse "$D^:src/coupons.js")"
expect "the new commit changes nothing but src/coupons.js"                 test "$(git diff --name-only "$(saved main)" main)" = "src/coupons.js"
expect_not "src/legacy-banner.js stays deleted"                            in_commit main src/legacy-banner.js
expect "the working tree is clean"                                         clean_tree
finish
